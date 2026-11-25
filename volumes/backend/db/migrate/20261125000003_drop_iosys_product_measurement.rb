class DropIosysProductMeasurement < ActiveRecord::Migration[8.1]
  def up
    drop_table :iosys_crawl_setting_exclude_keywords
    drop_table :iosys_crawl_setting_exclude_products
    drop_table :iosys_crawl_setting_required_keywords
    drop_table :iosys_products
    drop_table :iosys_crawl_settings
  end

  def down
    create_table :iosys_crawl_settings, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :keyword, null: false
      t.integer :min_price, default: 0, null: false
      t.integer :max_price, default: 0, null: false
      t.boolean :enabled, default: false, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id], name: "index_iosys_crawl_settings_on_product_id"
    end

    create_table :iosys_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :external_id, null: false
      t.string :name, null: false
      t.text :thumbnail_url
      t.integer :price, default: 0, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:external_id], name: "index_iosys_products_on_external_id", unique: true
      t.index [:product_id, :external_id], name: "index_iosys_products_on_product_id_and_external_id", unique: true
      t.index [:product_id], name: "index_iosys_products_on_product_id"
    end

    create_table :iosys_crawl_setting_required_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :iosys_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:iosys_crawl_setting_id, :keyword], name: "idx_on_iosys_crawl_setting_id_keyword_5beae71d90", unique: true
      t.index [:iosys_crawl_setting_id], name: "idx_on_iosys_crawl_setting_id_abd2c33544"
    end

    create_table :iosys_crawl_setting_exclude_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :iosys_crawl_setting_id
      t.string :external_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:iosys_crawl_setting_id, :external_id], name: "idx_on_iosys_crawl_setting_id_external_id_b0528c956e", unique: true
      t.index [:iosys_crawl_setting_id], name: "idx_on_iosys_crawl_setting_id_180f55a37c"
    end

    create_table :iosys_crawl_setting_exclude_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :iosys_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:iosys_crawl_setting_id, :keyword], name: "idx_on_iosys_crawl_setting_id_keyword_2429715633", unique: true
      t.index [:iosys_crawl_setting_id], name: "idx_on_iosys_crawl_setting_id_889c2c2e88"
    end

    add_foreign_key :iosys_crawl_setting_exclude_keywords, :iosys_crawl_settings
    add_foreign_key :iosys_crawl_setting_exclude_products, :iosys_crawl_settings
    add_foreign_key :iosys_crawl_setting_required_keywords, :iosys_crawl_settings
    add_foreign_key :iosys_crawl_settings, :products
    add_foreign_key :iosys_products, :products
  end
end
