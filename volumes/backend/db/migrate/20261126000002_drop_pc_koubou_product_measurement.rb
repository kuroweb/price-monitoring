class DropPcKoubouProductMeasurement < ActiveRecord::Migration[8.1]
  def up
    drop_table :pc_koubou_crawl_setting_exclude_keywords
    drop_table :pc_koubou_crawl_setting_exclude_products
    drop_table :pc_koubou_crawl_setting_required_keywords
    drop_table :pc_koubou_products
    drop_table :pc_koubou_crawl_settings
  end

  def down
    create_table :pc_koubou_crawl_settings, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :keyword, null: false
      t.integer :min_price, default: 0, null: false
      t.integer :max_price, default: 0, null: false
      t.boolean :enabled, default: false, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id], name: "index_pc_koubou_crawl_settings_on_product_id"
    end

    create_table :pc_koubou_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :external_id, null: false
      t.string :name, null: false
      t.text :thumbnail_url
      t.integer :price, default: 0, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:external_id], name: "index_pc_koubou_products_on_external_id", unique: true
      t.index [:product_id, :external_id], name: "index_pc_koubou_products_on_product_id_and_external_id", unique: true
      t.index [:product_id], name: "index_pc_koubou_products_on_product_id"
    end

    create_table :pc_koubou_crawl_setting_required_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :pc_koubou_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:pc_koubou_crawl_setting_id, :keyword], name: "idx_on_pc_koubou_crawl_setting_id_keyword_8e3b9acc35", unique: true
      t.index [:pc_koubou_crawl_setting_id], name: "idx_on_pc_koubou_crawl_setting_id_d2ecc2a271"
    end

    create_table :pc_koubou_crawl_setting_exclude_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :pc_koubou_crawl_setting_id
      t.string :external_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:pc_koubou_crawl_setting_id, :external_id], name: "idx_on_pc_koubou_crawl_setting_id_external_id_96823e00f8", unique: true
      t.index [:pc_koubou_crawl_setting_id], name: "idx_on_pc_koubou_crawl_setting_id_8b1b1a24af"
    end

    create_table :pc_koubou_crawl_setting_exclude_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :pc_koubou_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:pc_koubou_crawl_setting_id, :keyword], name: "idx_on_pc_koubou_crawl_setting_id_keyword_8c3917f08a", unique: true
      t.index [:pc_koubou_crawl_setting_id], name: "idx_on_pc_koubou_crawl_setting_id_f8f5317000"
    end

    add_foreign_key :pc_koubou_crawl_setting_exclude_keywords, :pc_koubou_crawl_settings
    add_foreign_key :pc_koubou_crawl_setting_exclude_products, :pc_koubou_crawl_settings
    add_foreign_key :pc_koubou_crawl_setting_required_keywords, :pc_koubou_crawl_settings
    add_foreign_key :pc_koubou_crawl_settings, :products
    add_foreign_key :pc_koubou_products, :products
  end
end
