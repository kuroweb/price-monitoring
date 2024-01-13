class AddKeywordColumnToYahooAuctionCrawlSetting < ActiveRecord::Migration[7.1]
  def change
    add_column :yahoo_auction_crawl_settings, :keyword, :string, null: false
  end
end
