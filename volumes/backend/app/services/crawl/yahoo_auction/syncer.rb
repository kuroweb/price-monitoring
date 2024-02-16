module Crawl
  module YahooAuction
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
        published_results = Crawl::YahooAuction::Published::Crawler.new(product:).execute
        unpublished_results = Crawl::YahooAuction::Unpublished::Crawler.new(product:).execute
        all_results = Crawl::YahooAuction::CrawlResults.new(published_results.results + unpublished_results.results)
        Crawl::YahooAuction::InspectCrawlResults.new(yahoo_auction_crawl_setting:, crawl_results: all_results).execute
      end

      def save(crawl_results)
        YahooAuctionProduct.transaction do
          upsert(crawl_results)
          delete(crawl_results)
        end
      end

      def upsert(crawl_results)
        upsert_params = crawl_results.results.map do |result|
          result.as_json.merge("product_id" => @product.id)
        end

        YahooAuctionProduct.upsert_all(upsert_params, record_timestamps: true)
      end

      def delete(crawl_results)
        YahooAuctionProduct
          .where(product_id: @product.id, published: true)
          .where.not(yahoo_auction_id: crawl_results.yahoo_auction_ids)
          .delete_all
      end

      def yahoo_auction_crawl_setting
        @yahoo_auction_crawl_setting ||= @product.yahoo_auction_crawl_setting
      end
    end
  end
end
