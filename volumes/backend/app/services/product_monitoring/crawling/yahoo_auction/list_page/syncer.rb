module ProductMonitoring
  module Crawling
    module YahooAuction
      module ListPage
        # 一覧の出品を保存する
        class Syncer
          def self.call(...)
            new(...).call
          end

          def initialize(crawl_setting:)
            @crawl_setting = crawl_setting
          end

          def call
            matched = Crawler.call(crawl_setting:).select { |listing| CrawlSetting::Matcher.call(crawl_setting:, listing:) }
            log_seller_coverage(matched)
            ProductMonitoring::CrawlResult.transaction do
              save(matched)
              CrawlResultCleaner.call(crawl_setting:)
            end
          end

          private

          attr_reader :crawl_setting

          # サイトの構造が変わって出品者IDを読めなくなったことに気付くため
          def log_seller_coverage(matched)
            Rails.logger.info("Product crawl seller ids: setting_id=#{crawl_setting.id} " \
                              "platform=#{SearchUrl::PLATFORM} listings=#{matched.size} " \
                              "identified=#{matched.count { |listing| listing[:seller_id] }}")
          end

          # 条件に一致した出品を保存する。除外した出品も価格などは更新し、excluded_at は上書きしない
          def save(matched)
            priced = matched.reject { |listing| listing[:price].nil? }
            return if priced.empty?

            upsert_rows(priced)
            update_listed_sold(priced)
          end

          # 内容が変わったときだけ更新日時を進める。売れた日は最初に記録した日を保ち、即決価格は一覧に無ければ保つ。
          # 出品者IDの補完で個別確認の間隔が変わらないよう、更新日時を進める比較に seller_id を含めない
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
                price = VALUES(price), ends_at = VALUES(ends_at), seller_id = COALESCE(VALUES(seller_id), seller_id),
                buyout_price = COALESCE(VALUES(buyout_price), product_monitoring_crawl_results.buyout_price),
                sold_at = COALESCE(product_monitoring_crawl_results.sold_at, IF(VALUES(sold), VALUES(sold_at), NULL)),
                recency_at = IF(IFNULL(VALUES(sold), 0),
                  COALESCE(product_monitoring_crawl_results.sold_at, VALUES(sold_at)),
                  product_monitoring_crawl_results.recency_at)
              SQL
          end

          def row(listing)
            { crawl_setting_id: crawl_setting.id, thumbnail_url: nil, sold: nil, buyout_price: nil,
              ends_at: nil, sold_at: nil, seller_id: nil }.merge(
                listing.slice(:platform, :external_id, :name, :product_url, :thumbnail_url, :price, :sold,
                              :buyout_price, :ends_at, :sold_at, :seller_id)
              ).merge(recency_at: inserted_recency(listing))
          end

          # 販売中と販売状態不明は初回保存時刻。売り切れは売れた日、売れた日が無ければ空
          def inserted_recency(listing)
            return listing[:sold_at] if listing[:sold] && listing[:sold_at]
            return nil if listing[:sold]

            Arel.sql("CURRENT_TIMESTAMP(6)")
          end

          # 販売状態の不明な既存の出品は一覧の販売中を反映し、一覧の売り切れは常に反映する
          def update_listed_sold(priced)
            available_ids = priced.select { |listing| listing[:sold] == false }.pluck(:external_id)
            sold_ids = priced.select { |listing| listing[:sold] }.pluck(:external_id)
            results = crawl_setting.crawl_results
            results.where(external_id: available_ids, sold: nil).update_all(sold: false) if available_ids.any? # rubocop:disable Rails/SkipsModelValidations
            if sold_ids.any? # rubocop:disable Style/GuardClause
              results.where(external_id: sold_ids).update_all("sold = TRUE, recency_at = sold_at") # rubocop:disable Rails/SkipsModelValidations
            end
          end
        end
      end
    end
  end
end
