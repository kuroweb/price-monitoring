module Crawl
  module YahooFleamarket
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

          YahooFleamarketProduct.transaction do
            upsert
            inspect
            enqueue_for_existence
          end
        end

        private

        attr_reader :product

        def upsert
          upsert_params = crawl_results.results.map do |result|
            result.attributes.merge("product_id" => product.id)
          end

          YahooFleamarketProduct.upsert_all(upsert_params, record_timestamps: true)
        end

        def inspect
          Crawl::YahooFleamarket::Inspect.call(product:)
        end

        def enqueue_for_existence
          job_params =
            YahooFleamarketProduct
            .where(product_id: product.id, published: true)
            .where.not(external_id: crawl_results.results.map(&:external_id))
            .map { |yahoo_fleamarket_product| [yahoo_fleamarket_product.id] }

          Crawl::YahooFleamarket::SyncProduct::SyncJob.perform_bulk(job_params)
        end

        def yahoo_auction_crawl_setting
          @yahoo_auction_crawl_setting ||= product.yahoo_auction_crawl_setting
        end

        def crawl_results
          @crawl_results ||= CrawlResults.new(published_results + unpublished_results)
        end

        def published_results
          Published::Crawler.new(product:).execute.results
        end

        def unpublished_results
          Unpublished::Crawler.new(product:).execute.results
        end
      end
    end
  end
end
