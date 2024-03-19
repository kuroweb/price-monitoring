class DropCalculateDailyYahooAuctionProduct < ActiveRecord::Migration[7.1]
  def change
    drop_table :calculate_daily_yahoo_auction_products do |t|
      t.bigint "product_id"
      t.integer "price"
      t.date "target_date", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["product_id", "target_date"], name: "idx_on_product_id_target_date_cf1660df56", unique: true
      t.index ["product_id"], name: "index_calculate_daily_yahoo_auction_products_on_product_id"
    end
  end
end
