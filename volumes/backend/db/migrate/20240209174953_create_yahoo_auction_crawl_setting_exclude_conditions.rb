class CreateYahooAuctionCrawlSettingExcludeConditions < ActiveRecord::Migration[7.1]
  def change
    create_table :yahoo_auction_crawl_setting_exclude_conditions do |t|
      t.references :yahoo_auction_crawl_setting, foreign_key: true

      t.string :keyword, null: true
      t.string :seller_id, null: true

      t.timestamps
    end
  end
end
