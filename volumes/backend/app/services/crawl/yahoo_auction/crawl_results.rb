# クロール結果のコレクションクラス
module Crawl
  module YahooAuction
    class CrawlResults
      attr_reader :results

      def initialize(results = [])
        @results = results
      end

      def add(result)
        results.push(result)
      end

      def external_ids
        results.map(&:external_id)
      end

      def yahoo_auction_crawl_results
        self.class.new(results.select { |result| result.platform == "yahoo_auction" })
      end

      def yahoo_fleamarket_crawl_results
        self.class.new(results.select { |result| result.platform == "yahoo_fleamarket" })
      end
    end
  end
end
