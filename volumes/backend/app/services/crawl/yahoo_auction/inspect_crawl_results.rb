# クローリング結果を検査する
module Crawl
  module YahooAuction
    class InspectCrawlResults
      def initialize(yahoo_auction_crawl_setting:, crawl_results:)
        @yahoo_auction_crawl_setting = yahoo_auction_crawl_setting
        @crawl_results = crawl_results
      end

      def execute
        crawl_results = inspect_name
        crawl_results
      end

      private

      attr_reader :yahoo_auction_crawl_setting, :crawl_results

      def inspect_name
        keywords = yahoo_auction_crawl_setting.keyword.downcase.split(" ")
        inspected_crawl_results = crawl_results.results.select do |crawl_result|
          keywords.all? { |keyword| crawl_result.name.downcase.include?(keyword) }
        end
        Crawl::YahooAuction::CrawlResults.new(inspected_crawl_results)
      end
    end
  end
end
