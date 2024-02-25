class ChangeYahooAuctionCrawlSettingExcludeKeywordToYahooAuctionExcludeKeyword < ActiveRecord::Migration[7.1]
  def change
    rename_table :yahoo_auction_crawl_setting_exclude_keywords, :yahoo_auction_crawl_setting_exclude_keywords
  end
end
