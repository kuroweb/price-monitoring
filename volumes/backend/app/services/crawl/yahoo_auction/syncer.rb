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
          save_yahoo_auction_products(crawl_results)
          save_yahoo_fleamarket_products(crawl_results)
        end
      end

      def save_yahoo_auction_products(crawl_results)
        upsert(YahooAuctionProduct, "yahoo_auction_id", crawl_results.yahoo_auction_crawl_results)
        delete(YahooAuctionProduct, "yahoo_auction_id", crawl_results.yahoo_auction_crawl_results)
      end

      def save_yahoo_fleamarket_products(crawl_results)
        upsert(YahooFleamarketProduct, "yahoo_fleamarket_id", crawl_results.yahoo_fleamarket_crawl_results)
        delete(YahooFleamarketProduct, "yahoo_fleamarket_id", crawl_results.yahoo_fleamarket_crawl_results)
      end

      def upsert(model, external_id_name, crawl_results)
        upsert_params = crawl_results.results.map do |result|
          result.as_json
                .merge("product_id" => product.id, external_id_name => result.external_id)
                .except("platform", "external_id")
        end

        model.upsert_all(upsert_params, record_timestamps: true)
      end

      def delete(model, external_id_name, crawl_results)
        model.where(product_id: product.id, published: true)
             .where.not(external_id_name => crawl_results.external_ids)
             .delete_all
      end

      def yahoo_auction_crawl_setting
        @yahoo_auction_crawl_setting ||= product.yahoo_auction_crawl_setting
      end
    end
  end
end
