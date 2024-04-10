class CreateYahooFleamarketDailyPurchaseSummaries < ActiveRecord::Migration[7.1]
  def change
    create_table :yahoo_fleamarket_daily_purchase_summaries do |t|
      t.references :product, foreign_key: true

      t.integer :average_purchase_price
      t.integer :purchase_count, default: 0
      t.date :date, null: false

      t.timestamps
    end

    add_index :yahoo_fleamarket_daily_purchase_summaries, %i[product_id date], unique: true
  end
end
