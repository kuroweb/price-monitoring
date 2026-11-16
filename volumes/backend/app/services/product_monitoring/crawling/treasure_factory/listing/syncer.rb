module ProductMonitoring
  module Crawling
    module TreasureFactory
      module Listing
        # 一覧の出品を保存する
        class Syncer
          def self.call(...)
            new(...).call
          end

          def initialize(product_crawl_setting:)
            @product_crawl_setting = product_crawl_setting
          end

          def call
            matched = Crawler.call(product_crawl_setting:).select { |listing| CrawlSettings::Matcher.call(product_crawl_setting:, listing:) }
            ProductCrawlResult.transaction do
              save(matched)
              CrawlResultCleaner.call(product_crawl_setting:)
            end
          end

          private

          attr_reader :product_crawl_setting

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
            ProductCrawlResult.upsert_all(rows, record_timestamps: true, on_duplicate: Arel.sql(<<~SQL.squish)) # rubocop:disable Rails/SkipsModelValidations
              updated_at = IF(name <=> VALUES(name) AND product_url <=> VALUES(product_url)
                AND thumbnail_url <=> VALUES(thumbnail_url) AND price <=> VALUES(price)
                AND end_date <=> VALUES(end_date) AND buyout_price <=> COALESCE(VALUES(buyout_price), buyout_price),
                product_crawl_results.updated_at, VALUES(updated_at)),
              name = VALUES(name), product_url = VALUES(product_url), thumbnail_url = VALUES(thumbnail_url),
              price = VALUES(price), end_date = VALUES(end_date),
              buyout_price = COALESCE(VALUES(buyout_price), product_crawl_results.buyout_price),
              bought_date = COALESCE(product_crawl_results.bought_date, IF(VALUES(sold), VALUES(bought_date), NULL))
            SQL
          end

          def row(listing)
            { product_crawl_setting_id: product_crawl_setting.id, thumbnail_url: nil, sold: nil, buyout_price: nil,
              end_date: nil, bought_date: nil }.merge(
                listing.slice(:platform, :external_id, :name, :product_url, :thumbnail_url, :price, :sold,
                              :buyout_price, :end_date, :bought_date)
              )
          end

          # 販売状態の不明な既存の出品は一覧の販売中を反映し、一覧の売り切れは常に反映する
          def update_listed_sold(priced)
            available_ids = priced.select { |listing| listing[:sold] == false }.pluck(:external_id)
            sold_ids = priced.select { |listing| listing[:sold] }.pluck(:external_id)
            results = product_crawl_setting.product_crawl_results
            results.where(external_id: available_ids, sold: nil).update_all(sold: false) if available_ids.any? # rubocop:disable Rails/SkipsModelValidations
            results.where(external_id: sold_ids).update_all(sold: true) if sold_ids.any? # rubocop:disable Rails/SkipsModelValidations
          end
        end
      end
    end
  end
end
