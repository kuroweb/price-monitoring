class DropMercariProductMeasurement < ActiveRecord::Migration[8.1]
  def up
    drop_table :mercari_crawl_setting_exclude_keywords
    drop_table :mercari_crawl_setting_exclude_products
    drop_table :mercari_crawl_setting_required_keywords
    drop_table :mercari_products
    drop_table :mercari_daily_purchase_summaries
    drop_table :mercari_crawl_settings
  end

  def down
    create_table :mercari_crawl_settings, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :keyword, null: false
      t.integer :category_id
      t.integer :min_price, default: 0, null: false
      t.integer :max_price, default: 0, null: false
      t.boolean :enabled, default: false, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id], name: "index_mercari_crawl_settings_on_product_id"
    end

    create_table :mercari_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :external_id, null: false
      t.string :name, null: false
      t.text :thumbnail_url
      t.integer :price, default: 0, null: false
      t.boolean :published, default: false, null: false
      t.datetime :bought_date
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id, :external_id], name: "index_mercari_products_on_product_id_and_external_id", unique: true
      t.index [:product_id], name: "index_mercari_products_on_product_id"
    end

    create_table :mercari_daily_purchase_summaries, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.integer :average_purchase_price
      t.integer :purchase_count, default: 0
      t.date :date, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id, :date], name: "index_mercari_daily_purchase_summaries_on_product_id_and_date", unique: true
      t.index [:product_id], name: "index_mercari_daily_purchase_summaries_on_product_id"
    end

    create_table :mercari_crawl_setting_required_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :mercari_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:mercari_crawl_setting_id, :keyword], name: "idx_on_mercari_crawl_setting_id_keyword_cc21910aea", unique: true
      t.index [:mercari_crawl_setting_id], name: "idx_on_mercari_crawl_setting_id_4659f97e15"
    end

    create_table :mercari_crawl_setting_exclude_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :mercari_crawl_setting_id
      t.string :external_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:mercari_crawl_setting_id, :external_id], name: "idx_on_mercari_crawl_setting_id_external_id_34002464be", unique: true
      t.index [:mercari_crawl_setting_id], name: "idx_on_mercari_crawl_setting_id_22de934ea6"
    end

    create_table :mercari_crawl_setting_exclude_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :mercari_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:mercari_crawl_setting_id, :keyword], name: "idx_on_mercari_crawl_setting_id_keyword_4e4cc0381b", unique: true
      t.index [:mercari_crawl_setting_id], name: "idx_on_mercari_crawl_setting_id_f56a952474"
    end

    add_foreign_key :mercari_crawl_setting_exclude_keywords, :mercari_crawl_settings
    add_foreign_key :mercari_crawl_setting_exclude_products, :mercari_crawl_settings
    add_foreign_key :mercari_crawl_setting_required_keywords, :mercari_crawl_settings
    add_foreign_key :mercari_crawl_settings, :products
    add_foreign_key :mercari_daily_purchase_summaries, :products
    add_foreign_key :mercari_products, :products
  end
end
