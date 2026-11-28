module ProductMonitoring
  module Crawling
    module Janpara
      module ListPage
        class Syncer
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

          def save(matched)
            priced = matched.reject { |listing| listing[:price].nil? }
            return if priced.empty?

            upsert_rows(priced)
            update_listed_sold(priced)
          end

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
                sold_at = COALESCE(product_monitoring_crawl_results.sold_at, IF(VALUES(sold), VALUES(sold_at), NULL)),
                recency_at = IF(IFNULL(VALUES(sold), 0),
                  COALESCE(product_monitoring_crawl_results.sold_at, VALUES(sold_at)),
                  product_monitoring_crawl_results.recency_at)
              SQL
          end

          def row(listing)
            { crawl_setting_id: crawl_setting.id, thumbnail_url: nil, sold: nil, buyout_price: nil,
              ends_at: nil, sold_at: nil }.merge(
                listing.slice(:platform, :external_id, :name, :product_url, :thumbnail_url, :price, :sold,
                              :buyout_price, :ends_at, :sold_at)
              ).merge(recency_at: inserted_recency(listing))
          end

          def inserted_recency(listing)
            return listing[:sold_at] if listing[:sold] && listing[:sold_at]
            return nil if listing[:sold]

            Arel.sql("CURRENT_TIMESTAMP(6)")
          end

          def update_listed_sold(priced)
            available_ids = priced.select { |listing| listing[:sold] == false }.pluck(:external_id)
            sold_ids = priced.select { |listing| listing[:sold] }.pluck(:external_id)
            results = crawl_setting.crawl_results
            results.where(external_id: available_ids, sold: nil).update_all(sold: false) if available_ids.any? # rubocop:disable Rails/SkipsModelValidations
            if sold_ids.any? # rubocop:disable Style/GuardClause
              results.where(external_id: sold_ids).update_all("sold = TRUE, recency_at = sold_at") # rubocop:disable Rails/SkipsModelValidations
            end
          end

          def listings
            crawl_setting.crawl_results.where(platform: SearchUrl::PLATFORM)
          end

          def update_sold(results)
            sold_ids = results.select { |result| result[:sold] == true }.pluck(:external_id)
            available_ids = results.select { |result| result[:sold] == false }.pluck(:external_id)
            if sold_ids.any?
              listings.where(external_id: sold_ids).update_all("sold = TRUE, recency_at = sold_at") # rubocop:disable Rails/SkipsModelValidations
            end
            return if available_ids.empty?

            listings.where(external_id: available_ids).update_all("sold = FALSE, recency_at = created_at") # rubocop:disable Rails/SkipsModelValidations
          end

          # 打ち切りや失敗のある一覧では消えたと判断できないので、クローラーが全URLを最後まで取得できたときだけ反映する
          def sell_out_missing(crawled)
            return unless crawled[:complete]

            returned_ids = crawled[:listings].pluck(:external_id)
            missing = listings.where(updated_at: ..SOLD_OUT_AFTER.ago)
            missing = missing.where.not(external_id: returned_ids) if returned_ids.any?
            missing.update_all("sold = TRUE, recency_at = sold_at") # rubocop:disable Rails/SkipsModelValidations
          end
        end
      end
    end
  end
end
