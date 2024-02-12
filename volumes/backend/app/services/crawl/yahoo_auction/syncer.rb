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

        published_crawl_results = crawl_published

        save(published_crawl_results)
      end

      private

      attr_reader :product

      def crawl_published
        crawl_results = Crawl::YahooAuction::Published::Crawler.new(product:).execute
        inspect(crawl_results)
      end

      def crawl_unpublished
        # TODO: 後で実装する
      end

      def inspect(crawl_results)
        Crawl::YahooAuction::InspectCrawlResults.new(yahoo_auction_crawl_setting:, crawl_results:).execute
      end

      def save(crawl_results)
        # TODO: published, unpublishedを比較してsaveする処理に変更する
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

      def yahoo_auction_crawl_setting
        @yahoo_auction_crawl_setting ||= product.yahoo_auction_crawl_setting
      end
    end
  end
end
