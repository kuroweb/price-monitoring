class DropYahooAuctionProductMeasurement < ActiveRecord::Migration[8.1]
  def up
    drop_table :yahoo_auction_crawl_setting_exclude_keywords
    drop_table :yahoo_auction_crawl_setting_exclude_products
    drop_table :yahoo_auction_crawl_setting_required_keywords
    drop_table :yahoo_auction_crawl_settings
    drop_table :yahoo_auction_daily_purchase_summaries
    drop_table :yahoo_auction_products
  end

  def down
    create_table :yahoo_auction_crawl_settings, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.integer :category_id, default: 0
      t.integer :min_price, default: 0, null: false
      t.integer :max_price, default: 0, null: false
      t.boolean :enabled, default: false, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :keyword, null: false
      t.index [:product_id], name: "index_yahoo_auction_crawl_settings_on_product_id"
    end

    create_table :yahoo_auction_crawl_setting_exclude_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :yahoo_auction_crawl_setting_id
      t.string :keyword
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:yahoo_auction_crawl_setting_id, :keyword], name: "idx_on_yahoo_auction_crawl_setting_id_keyword_9341e10548", unique: true
      t.index [:yahoo_auction_crawl_setting_id], name: "idx_on_yahoo_auction_crawl_setting_id_fb93459e66"
    end

    create_table :yahoo_auction_crawl_setting_exclude_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :yahoo_auction_crawl_setting_id
      t.string :external_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:yahoo_auction_crawl_setting_id, :external_id], name: "idx_on_yahoo_auction_crawl_setting_id_external_id_c904750663", unique: true
      t.index [:yahoo_auction_crawl_setting_id], name: "idx_on_yahoo_auction_crawl_setting_id_b30a20343c"
    end

    create_table :yahoo_auction_crawl_setting_required_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :yahoo_auction_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:yahoo_auction_crawl_setting_id, :keyword], name: "idx_on_yahoo_auction_crawl_setting_id_keyword_daee6cea4b", unique: true
      t.index [:yahoo_auction_crawl_setting_id], name: "idx_on_yahoo_auction_crawl_setting_id_49589afeb2"
    end

    create_table :yahoo_auction_daily_purchase_summaries, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.integer :average_purchase_price
      t.integer :purchase_count, default: 0
      t.date :date, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id, :date], name: "idx_on_product_id_date_d63712c38b", unique: true
      t.index [:product_id], name: "index_yahoo_auction_daily_purchase_summaries_on_product_id"
    end

    create_table :yahoo_auction_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :external_id, null: false
      t.string :seller_id, null: false
      t.string :name, null: false
      t.text :thumbnail_url
      t.integer :price, default: 0, null: false
      t.integer :buyout_price
      t.boolean :published, default: false, null: false
      t.datetime :bought_date
      t.datetime :end_date
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id, :external_id], name: "index_yahoo_auction_products_on_product_id_and_external_id", unique: true
      t.index [:product_id], name: "index_yahoo_auction_products_on_product_id"
    end

    add_foreign_key :yahoo_auction_crawl_setting_exclude_keywords, :yahoo_auction_crawl_settings
    add_foreign_key :yahoo_auction_crawl_setting_exclude_products, :yahoo_auction_crawl_settings
    add_foreign_key :yahoo_auction_crawl_setting_required_keywords, :yahoo_auction_crawl_settings
    add_foreign_key :yahoo_auction_crawl_settings, :products
    add_foreign_key :yahoo_auction_daily_purchase_summaries, :products
    add_foreign_key :yahoo_auction_products, :products
  end
end
