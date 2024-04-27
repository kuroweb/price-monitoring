module Crawl
  module YahooAuction
    module SyncProduct
      class Syncer
        def self.call(...)
          new(...).call
        end

        def initialize(yahoo_auction_product:)
          @yahoo_auction_product = yahoo_auction_product
        end

        def call
          return unless yahoo_auction_crawl_setting.enabled?

          crawl_result.deletable ? delete : update
        end

        private

        attr_reader :yahoo_auction_product

        def update
          yahoo_auction_product.update(crawl_result.attributes.except("deletable"))
        end

        def delete
          yahoo_auction_product.destroy
        end

        def yahoo_auction_crawl_setting
          @yahoo_auction_crawl_setting ||= yahoo_auction_product.product.yahoo_auction_crawl_setting
        end

        def crawl_result
          @crawl_result ||= Crawler.call(yahoo_auction_product:)
        end
      end
    end
  end
end
