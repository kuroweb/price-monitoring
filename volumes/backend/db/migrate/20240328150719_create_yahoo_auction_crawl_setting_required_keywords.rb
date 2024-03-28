class CreateYahooAuctionCrawlSettingRequiredKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :yahoo_auction_crawl_setting_required_keywords do |t|
      t.references :yahoo_auction_crawl_setting, foreign_key: true

      t.string :keyword, null: false

      t.timestamps
    end
  end
end
