# クローリング結果を検査する
module Crawl
  module YahooAuction
    class InspectCrawlResults
      def initialize(yahoo_auction_crawl_setting:, crawl_results:)
        @yahoo_auction_crawl_setting = yahoo_auction_crawl_setting
        @crawl_results = crawl_results
      end

      def execute
        inspected_crawl_results = crawl_results.results.select { |crawl_result| inspect(crawl_result) }
        Crawl::YahooAuction::CrawlResults.new(inspected_crawl_results)
      end

      private

      attr_reader :yahoo_auction_crawl_setting, :crawl_results

      def inspect(crawl_result)
        inspect_include_keyword(crawl_result) \
          && inspect_exclude_keyword(crawl_result) \
          && inspect_exclude_yahoo_auction_id(crawl_result) \
          && inspect_exclude_seller_id(crawl_result)
      end

      def inspect_include_keyword(crawl_result)
        include_keywords.all? { |keyword| crawl_result.name.downcase.include?(keyword) }
      end

      def inspect_exclude_keyword(crawl_result)
        exclude_keywords.all? { |keyword| crawl_result.name.downcase.exclude?(keyword) }
      end

      def inspect_exclude_yahoo_auction_id(crawl_result)
        exclude_yahoo_auction_ids.exclude?(crawl_result.yahoo_auction_id)
      end

      def inspect_exclude_seller_id(crawl_result)
        exclude_seller_ids.exclude?(crawl_result.seller_id)
      end

      def include_keywords
        @include_keywords ||= yahoo_auction_crawl_setting.keyword.downcase.split(" ")
      end

      def exclude_keywords
        @exclude_keywords ||=
          yahoo_auction_crawl_setting
          .yahoo_auction_crawl_setting_exclude_keywords.where.not(keyword: nil)
          .pluck(:keyword).map(&:downcase)
      end

      def exclude_yahoo_auction_ids
        @exclude_yahoo_auction_ids ||=
          yahoo_auction_crawl_setting
          .yahoo_auction_crawl_setting_exclude_keywords.where.not(yahoo_auction_id: nil)
          .pluck(:yahoo_auction_id)
      end

      def exclude_seller_ids
        @exclude_seller_ids ||=
          yahoo_auction_crawl_setting
          .yahoo_auction_crawl_setting_exclude_keywords.where.not(seller_id: nil)
          .pluck(:seller_id)
      end
    end
  end
end
