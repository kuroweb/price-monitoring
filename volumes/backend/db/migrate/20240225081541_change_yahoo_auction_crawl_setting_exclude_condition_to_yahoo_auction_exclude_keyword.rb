class ChangeYahooAuctionCrawlSettingExcludeConditionToYahooAuctionExcludeKeyword < ActiveRecord::Migration[7.1]
  def change
    rename_table :yahoo_auction_crawl_setting_exclude_conditions, :yahoo_auction_crawl_setting_exclude_keywords
  end
end
