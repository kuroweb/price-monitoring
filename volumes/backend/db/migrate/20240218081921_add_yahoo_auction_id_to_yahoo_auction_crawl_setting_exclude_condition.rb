class AddYahooAuctionIdToYahooAuctionCrawlSettingExcludeCondition < ActiveRecord::Migration[7.1]
  def change
    add_column :yahoo_auction_crawl_setting_exclude_conditions,
               :yahoo_auction_id, :string, null: true, default: nil, after: :yahoo_auction_crawl_setting_id
  end
end
