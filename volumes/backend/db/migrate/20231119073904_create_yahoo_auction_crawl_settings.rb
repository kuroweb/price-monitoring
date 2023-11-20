class CreateYahooAuctionCrawlSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :yahoo_auction_crawl_settings do |t|
      t.references :product, foreign_key: true

      t.integer :category_id, null: true, default: 0
      t.integer :min_price, null: false, default: 0
      t.integer :max_price, null: false, default: 0
      t.boolean :enabled, null: false, default: false

      t.timestamps
    end
  end
end
