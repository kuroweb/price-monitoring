module Api
  class YahooAuctionCrawlSettingSerializer < BaseSerializer
    def initialize(yahoo_auction_crawl_setting)
      @yahoo_auction_crawl_setting = yahoo_auction_crawl_setting
    end

    private

    def json
      yahoo_auction_crawl_setting_json.merge(
        {
          yahoo_auction_crawl_setting_exclude_keywords: yahoo_auction_crawl_setting_exclude_keywords_json,
          yahoo_auction_crawl_setting_required_keywords: yahoo_auction_crawl_setting_required_keywords_json
        }
      )
    end

    def yahoo_auction_crawl_setting_json
      @yahoo_auction_crawl_setting.as_json
    end

    def yahoo_auction_crawl_setting_exclude_keywords_json
      @yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_exclude_keywords.map do |p|
        YahooAuctionCrawlSettingExcludeKeywordSerializer.new(p).render_json
      end
    end

    def yahoo_auction_crawl_setting_required_keywords_json
      @yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_required_keywords.map do |p|
        YahooAuctionCrawlSettingRequiredKeywordSerializer.new(p).render_json
      end
    end
  end
end
