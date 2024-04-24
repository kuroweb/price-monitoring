module Crawl
  module YahooAuction
    module SyncProducts
      class Syncer
        def self.call(...)
          new(...).call
        end

        def initialize(product:)
          @product = product
        end

        def call
          return unless yahoo_auction_crawl_setting.enabled?

          crawl_results = fetch_crawl_results
          save(crawl_results)
        end

        private

        attr_reader :product

        def fetch_crawl_results
          all_results = CrawlResults.new(published_results + unpublished_results)
          InspectCrawlResults.new(yahoo_auction_crawl_setting:, crawl_results: all_results).execute
        end

        def published_results
          Published::Crawler.new(product:).execute.results
        end

        def unpublished_results
          Unpublished::Crawler.new(product:).execute.results
        end

        def save(crawl_results)
          ApplicationRecord.transaction do
            save_products("yahoo_auction", crawl_results)
            save_products("yahoo_fleamarket", crawl_results)
          end
        end

        def save_products(platform, crawl_results)
          upsert(platform, crawl_results)
          delete(platform, crawl_results)
        end

        def upsert(platform, crawl_results)
          model = "#{platform}_product".camelize.constantize
          external_id = "#{platform}_id"
          results = crawl_results.send("#{platform}_results")

          upsert_params = results.map do |result|
            result.attributes
                  .merge("product_id" => product.id, external_id => result.external_id)
                  .slice(*model.column_names)
          end

          model.upsert_all(upsert_params, record_timestamps: true)
        end

        def delete(platform, crawl_results)
          model = "#{platform}_product".camelize.constantize
          external_id = "#{platform}_id"
          external_ids = crawl_results.send("#{platform}_results").map(&:external_id)

          model.where(product_id: product.id, published: true)
               .where.not(external_id => external_ids)
               .delete_all
        end

        def yahoo_auction_crawl_setting
          @yahoo_auction_crawl_setting ||= product.yahoo_auction_crawl_setting
        end
      end
    end
  end
end
