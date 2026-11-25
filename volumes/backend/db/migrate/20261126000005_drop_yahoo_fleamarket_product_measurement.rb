class DropYahooFleamarketProductMeasurement < ActiveRecord::Migration[8.1]
  def up
    drop_table :yahoo_fleamarket_daily_purchase_summaries
    drop_table :yahoo_fleamarket_products
  end

  def down
    create_table :yahoo_fleamarket_daily_purchase_summaries, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.integer :average_purchase_price
      t.integer :purchase_count, default: 0
      t.date :date, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id, :date], name: "idx_on_product_id_date_bd09f0e249", unique: true
      t.index [:product_id], name: "index_yahoo_fleamarket_daily_purchase_summaries_on_product_id"
    end

    create_table :yahoo_fleamarket_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :external_id, null: false
      t.string :seller_id, null: false
      t.string :name, null: false
      t.text :thumbnail_url
      t.integer :price, default: 0, null: false
      t.boolean :published, default: false, null: false
      t.datetime :bought_date
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id, :external_id], name: "index_yahoo_fleamarket_products_on_product_id_and_external_id", unique: true
      t.index [:product_id], name: "index_yahoo_fleamarket_products_on_product_id"
    end

    add_foreign_key :yahoo_fleamarket_daily_purchase_summaries, :products
    add_foreign_key :yahoo_fleamarket_products, :products
  end
end
