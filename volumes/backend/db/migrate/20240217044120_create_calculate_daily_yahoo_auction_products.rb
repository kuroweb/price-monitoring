class CreateCalculateDailyYahooAuctionProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :calculate_daily_yahoo_auction_products do |t|
      t.references :product, foreign_key: true

      t.integer :price, null: true
      t.date :target_date, null: false

      t.timestamps
    end
  end
end
