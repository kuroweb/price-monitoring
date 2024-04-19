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
        CrawlResults.new(inspected_crawl_results)
      end

      private

      attr_reader :yahoo_auction_crawl_setting, :crawl_results

      def inspect(crawl_result)
        inspect_required_keyword(crawl_result) && inspect_exclude_keyword(crawl_result) && inspect_buyable(crawl_result)
      end

      def inspect_required_keyword(crawl_result)
        required_keywords.all? { |keyword| normalize_keyword(crawl_result.name).include?(keyword) }
      end

      def inspect_exclude_keyword(crawl_result)
        exclude_keywords.all? { |keyword| normalize_keyword(crawl_result.name).exclude?(keyword) }
      end

      # 即決価格が希望額以内 OR 現在価格が希望額以内かつ終了日が1日以内
      def inspect_buyable(crawl_result)
        return true if crawl_result.platform == "yahoo_fleamarket"
        return true if crawl_result.published == false
        return true if crawl_result.end_date <= Time.current.since(1.day)
        return true if crawl_result.buyout_price && crawl_result.buyout_price <= yahoo_auction_crawl_setting.max_price

        false
      end

      def required_keywords
        @required_keywords ||=
          yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_required_keywords
                                     .pluck(:keyword)
                                     .map { |keyword| normalize_keyword(keyword) }
      end

      def exclude_keywords
        @exclude_keywords ||=
          yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_exclude_keywords
                                     .pluck(:keyword)
                                     .map { |keyword| normalize_keyword(keyword) }
      end

      def normalize_keyword(keyword)
        keyword.tr("Ａ-Ｚ０-９", "A-Z0-9").downcase
      end
    end
  end
end
