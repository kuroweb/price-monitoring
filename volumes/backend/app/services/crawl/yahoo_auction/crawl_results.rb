# クロール結果のコレクションクラス
module Crawl
  module YahooAuction
    class CrawlResults
      attr_reader :results

      def initialize(results = [])
        @results = results
      end

      def add(result)
        @results.push(result)
      end

      def yahoo_auction_ids
        results.map(&:yahoo_auction_id)
      end
    end
  end
end
