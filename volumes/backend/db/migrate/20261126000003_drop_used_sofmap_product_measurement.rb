class DropUsedSofmapProductMeasurement < ActiveRecord::Migration[8.1]
  def up
    drop_table :used_sofmap_crawl_setting_exclude_keywords
    drop_table :used_sofmap_crawl_setting_exclude_products
    drop_table :used_sofmap_crawl_setting_required_keywords
    drop_table :used_sofmap_products
    drop_table :used_sofmap_crawl_settings
  end

  def down
    create_table :used_sofmap_crawl_settings, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :keyword, null: false
      t.integer :min_price, default: 0, null: false
      t.integer :max_price, default: 0, null: false
      t.boolean :enabled, default: false, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id], name: "index_used_sofmap_crawl_settings_on_product_id"
    end

    create_table :used_sofmap_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :external_id, null: false
      t.string :name, null: false
      t.text :thumbnail_url
      t.integer :price, default: 0, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:external_id], name: "index_used_sofmap_products_on_external_id", unique: true
      t.index [:product_id, :external_id], name: "index_used_sofmap_products_on_product_id_and_external_id", unique: true
      t.index [:product_id], name: "index_used_sofmap_products_on_product_id"
    end

    create_table :used_sofmap_crawl_setting_required_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :used_sofmap_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:used_sofmap_crawl_setting_id, :keyword], name: "idx_on_used_sofmap_crawl_setting_id_keyword_7296d7cbc9", unique: true
      t.index [:used_sofmap_crawl_setting_id], name: "idx_on_used_sofmap_crawl_setting_id_57a4411deb"
    end

    create_table :used_sofmap_crawl_setting_exclude_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :used_sofmap_crawl_setting_id
      t.string :external_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:used_sofmap_crawl_setting_id, :external_id], name: "idx_on_used_sofmap_crawl_setting_id_external_id_d8c3f14b71", unique: true
      t.index [:used_sofmap_crawl_setting_id], name: "idx_on_used_sofmap_crawl_setting_id_516fe376cb"
    end

    create_table :used_sofmap_crawl_setting_exclude_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :used_sofmap_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:used_sofmap_crawl_setting_id, :keyword], name: "idx_on_used_sofmap_crawl_setting_id_keyword_7475198f68", unique: true
      t.index [:used_sofmap_crawl_setting_id], name: "idx_on_used_sofmap_crawl_setting_id_7f42917bfe"
    end

    add_foreign_key :used_sofmap_crawl_setting_exclude_keywords, :used_sofmap_crawl_settings
    add_foreign_key :used_sofmap_crawl_setting_exclude_products, :used_sofmap_crawl_settings
    add_foreign_key :used_sofmap_crawl_setting_required_keywords, :used_sofmap_crawl_settings
    add_foreign_key :used_sofmap_crawl_settings, :products
    add_foreign_key :used_sofmap_products, :products
  end
end
