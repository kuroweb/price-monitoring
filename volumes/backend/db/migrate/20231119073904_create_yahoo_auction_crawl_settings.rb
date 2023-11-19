class CreateYahooAuctionCrawlSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :yahoo_auction_crawl_settings do |t|
      t.references :product, index: true

      t.boolean :enabled, null: false, default: false

      t.timestamps
    end
  end
end
