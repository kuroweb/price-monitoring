module Api
  class YahooAuctionCrawlSettingRequiredKeywordSerializer < BaseSerializer
    def initialize(yahoo_auction_crawl_setting_required_keyword)
      @yahoo_auction_crawl_setting_required_keyword = yahoo_auction_crawl_setting_required_keyword
    end

    private

    def json
      @yahoo_auction_crawl_setting_required_keyword.as_json
    end
  end
end
