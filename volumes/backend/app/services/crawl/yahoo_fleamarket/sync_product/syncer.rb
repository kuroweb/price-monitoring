module Crawl
  module YahooFleamarket
    module SyncProduct
      class Syncer
        def self.call(...)
          new(...).call
        end

        def initialize(yahoo_fleamarket_product:)
          @yahoo_fleamarket_product = yahoo_fleamarket_product
        end

        def call
          return unless yahoo_auction_crawl_setting.enabled?

          crawl_result.deleted ? delete : update
        end

        private

        attr_reader :yahoo_fleamarket_product

        def update
          yahoo_fleamarket_product.update(crawl_result.attributes.except("deleted"))
        end

        def delete
          yahoo_fleamarket_product.destroy
        end

        def yahoo_auction_crawl_setting
          @yahoo_auction_crawl_setting ||= yahoo_fleamarket_product.product.yahoo_auction_crawl_setting
        end

        def crawl_result
          @crawl_result ||= Crawler.call(yahoo_fleamarket_product:)
        end
      end
    end
  end
end
