# クローリング結果を検査する
module Crawl
  module YahooAuction
    class InspectCrawlResults
      def initialize(yahoo_auction_crawl_setting:, crawl_results:)
        @yahoo_auction_crawl_setting = yahoo_auction_crawl_setting
        @crawl_results = crawl_results
      end

      def execute
        binding.pry
        inspected_crawl_results = crawl_results.results.select { |crawl_result| inspect(crawl_result) }
        Crawl::YahooAuction::CrawlResults.new(inspected_crawl_results)
      end

      private

      attr_reader :yahoo_auction_crawl_setting, :crawl_results

      def inspect(crawl_result)
        inspect_include_keyword(crawl_result) && inspect_exclude_keyword(crawl_result)
      end

      def inspect_include_keyword(crawl_result)
        include_keywords.all? { |keyword| crawl_result.name.downcase.include?(keyword) }
      end

      def inspect_exclude_keyword(crawl_result)
        exclude_keywords.all? { |keyword| crawl_result.name.downcase.exclude?(keyword) }
      end

      def include_keywords
        @include_keywords ||= yahoo_auction_crawl_setting.keyword.downcase.split(" ")
      end

      def exclude_keywords
        @exclude_keywords ||= yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_exclude_keywords
                                                         .where.not(keyword: nil).pluck(:keyword)
      end
    end
  end
end
