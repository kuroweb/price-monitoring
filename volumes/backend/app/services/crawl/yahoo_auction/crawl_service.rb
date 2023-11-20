module Crawl
  module YahooAuction
    class CrawlService
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        return unless crawl_setting.enabled?

        results = Crawl::YahooAuction::Crawler.new(product:).execute
        save(results)
      end

      private

      attr_reader :product

      def crawl_setting
        @crawl_setting ||= product.yahoo_auction_crawl_setting
      end

      def save(results)
        YahooAuctionProduct.upsert_all(results, record_timestamps: true)
      end
    end
  end
end
