class CreateYahooAuctionCrawlSettingExcludeProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :yahoo_auction_crawl_setting_exclude_products do |t|
      t.references :yahoo_auction_crawl_setting, foreign_key: true

      t.string :external_id, null: false

      t.timestamps
    end

    add_index :yahoo_auction_crawl_setting_exclude_products, %i[yahoo_auction_crawl_setting_id external_id],
              unique: true
  end
end
