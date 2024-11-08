module Api
  class YahooAuctionCrawlSettingExcludeKeywordSerializer < BaseSerializer
    def initialize(yahoo_auction_crawl_setting_exclude_keyword)
      @yahoo_auction_crawl_setting_exclude_keyword = yahoo_auction_crawl_setting_exclude_keyword
    end

    private

    def json
      @yahoo_auction_crawl_setting_exclude_keyword.as_json
    end
  end
end
