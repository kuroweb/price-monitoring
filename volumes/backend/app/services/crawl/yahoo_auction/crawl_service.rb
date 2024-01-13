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

        crawl_results = Crawl::YahooAuction::Crawler.new(product:).execute
        save(crawl_results)
      end

      private

      attr_reader :product

      def crawl_setting
        @crawl_setting ||= product.yahoo_auction_crawl_setting
      end

      def save(crawl_results)
        YahooAuctionProduct.transaction do
          update_published_products(crawl_results)
          update_unpublished_products(crawl_results)
        end
      end

      def update_published_products(crawl_results)
        upsert_params = crawl_results.results.map do |result|
          result.as_json.merge("product_id" => product.id)
        end

        YahooAuctionProduct.upsert_all(upsert_params, record_timestamps: true)
      end

      def update_unpublished_products(crawl_results)
        YahooAuctionProduct
          .where(product_id: product.id, published: true)
          .where.not(yahoo_auction_id: crawl_results.yahoo_auction_ids)
          .update_all(published: false)
      end
    end
  end
end
