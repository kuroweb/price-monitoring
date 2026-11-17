module ProductMonitoring
  module Crawling
    module Janpara
      module ListPage
        # 一覧の出品を保存し、一覧の売り切れ表示と、完全に取得できた一覧から消えた出品を販売状態に反映する
        class Syncer
          # 一覧から消えた出品を売り切れとみなすまでの時間
          SOLD_OUT_AFTER = 3.hours

          def self.call(...)
            new(...).call
          end

          def initialize(crawl_setting:)
            @crawl_setting = crawl_setting
          end

          def call
            crawled = Crawler.call(crawl_setting:)
            matched = crawled[:listings].select { |listing| CrawlSetting::Matcher.call(crawl_setting:, listing:) }
            ProductMonitoring::CrawlResult.transaction do
              save(matched)
              update_sold(crawled[:listings])
              sell_out_missing(crawled)
              CrawlResultCleaner.call(crawl_setting:)
            end
          end

          private

          attr_reader :crawl_setting

          # 条件に一致した出品を保存する。除外した出品も価格などは更新し、excluded_at は上書きしない
          def save(matched)
            priced = matched.reject { |listing| listing[:price].nil? }
            return if priced.empty?

            upsert_rows(priced)
            update_listed_sold(priced)
          end

          # 内容が変わったときだけ更新日時を進める。売れた日は最初に記録した日を保ち、即決価格は一覧に無ければ保つ。
          # 一覧の全件を1文で書き込むので、モデルの検証は通さない
          def upsert_rows(priced)
            rows = priced.map { |listing| row(listing) }
            ProductMonitoring::CrawlResult.upsert_all( # rubocop:disable Rails/SkipsModelValidations
              rows, record_timestamps: true, on_duplicate: Arel.sql(<<~SQL.squish))
                updated_at = IF(name <=> VALUES(name) AND product_url <=> VALUES(product_url)
                  AND thumbnail_url <=> VALUES(thumbnail_url) AND price <=> VALUES(price)
                  AND ends_at <=> VALUES(ends_at) AND buyout_price <=> COALESCE(VALUES(buyout_price), buyout_price),
                  product_monitoring_crawl_results.updated_at, VALUES(updated_at)),
                name = VALUES(name), product_url = VALUES(product_url), thumbnail_url = VALUES(thumbnail_url),
                price = VALUES(price), ends_at = VALUES(ends_at),
                buyout_price = COALESCE(VALUES(buyout_price), product_monitoring_crawl_results.buyout_price),
                sold_at = COALESCE(product_monitoring_crawl_results.sold_at, IF(VALUES(sold), VALUES(sold_at), NULL))
              SQL
          end

          def row(listing)
            { crawl_setting_id: crawl_setting.id, thumbnail_url: nil, sold: nil, buyout_price: nil,
              ends_at: nil, sold_at: nil }.merge(
                listing.slice(:platform, :external_id, :name, :product_url, :thumbnail_url, :price, :sold,
                              :buyout_price, :ends_at, :sold_at)
              )
          end

          # 販売状態の不明な既存の出品は一覧の販売中を反映し、一覧の売り切れは常に反映する
          def update_listed_sold(priced)
            available_ids = priced.select { |listing| listing[:sold] == false }.pluck(:external_id)
            sold_ids = priced.select { |listing| listing[:sold] }.pluck(:external_id)
            results = crawl_setting.crawl_results
            results.where(external_id: available_ids, sold: nil).update_all(sold: false) if available_ids.any? # rubocop:disable Rails/SkipsModelValidations
            results.where(external_id: sold_ids).update_all(sold: true) if sold_ids.any? # rubocop:disable Rails/SkipsModelValidations
          end

          def listings
            crawl_setting.crawl_results.where(platform: SearchUrl::PLATFORM)
          end

          # 価格が無くても反映する。同じ出品が両方で返るときは販売中を後に適用する
          def update_sold(results)
            [true, false].each do |sold|
              ids = results.select { |result| result[:sold] == sold }.pluck(:external_id)
              listings.where(external_id: ids).update_all(sold:) if ids.any? # rubocop:disable Rails/SkipsModelValidations
            end
          end

          # 打ち切りや失敗のある一覧では消えたと判断できないので、クローラーが全URLを最後まで取得できたときだけ反映する
          def sell_out_missing(crawled)
            return unless crawled[:complete]

            returned_ids = crawled[:listings].pluck(:external_id)
            missing = listings.where(updated_at: ..SOLD_OUT_AFTER.ago)
            missing = missing.where.not(external_id: returned_ids) if returned_ids.any?
            missing.update_all(sold: true) # rubocop:disable Rails/SkipsModelValidations
          end
        end
      end
    end
  end
end
