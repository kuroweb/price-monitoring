class YahooAuctionCrawlSettingSerializer < BaseSerializer
  delegate(*YahooAuctionCrawlSetting.column_names, to: :yahoo_auction_crawl_setting)

  attr_reader :yahoo_auction_crawl_setting

  def initialize(yahoo_auction_crawl_setting)
    @yahoo_auction_crawl_setting = yahoo_auction_crawl_setting
  end

  private

  def attribute_names
    YahooAuctionCrawlSetting.column_names
  end
end
