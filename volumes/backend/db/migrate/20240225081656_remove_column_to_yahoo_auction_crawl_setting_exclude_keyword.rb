class RemoveColumnToYahooAuctionCrawlSettingExcludeKeyword < ActiveRecord::Migration[7.1]
  def change
    remove_column :yahoo_auction_crawl_setting_exclude_keywords, :yahoo_auction_id, :string
    remove_column :yahoo_auction_crawl_setting_exclude_keywords, :seller_id, :string
  end
end
