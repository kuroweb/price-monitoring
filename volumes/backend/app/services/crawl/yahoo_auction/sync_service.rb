module Crawl
  module YahooAuction
    class SyncService
      def self.call(...)
        new(...).call
      end

      def initialize(yahoo_auction_product:)
        @yahoo_auction_product = yahoo_auction_product
      end

      def call
        return unless crawl_setting.enabled?

        result = Crawl::YahooAuction::Syncer.new(yahoo_auction_product:).execute
        save(result)
      end

      private

      attr_reader :yahoo_auction_product

      def crawl_setting
        @crawl_setting ||= yahoo_auction_product.product.yahoo_auction_crawl_setting
      end

      def save(result)
        YahooAuctionProduct.upsert(result, record_timestamps: true)
      end
    end
  end
end
