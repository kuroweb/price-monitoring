class DropJanparaProductMeasurement < ActiveRecord::Migration[8.1]
  def up
    drop_table :janpara_crawl_setting_exclude_keywords
    drop_table :janpara_crawl_setting_exclude_products
    drop_table :janpara_crawl_setting_required_keywords
    drop_table :janpara_products
    drop_table :janpara_crawl_settings
  end

  def down
    create_table :janpara_crawl_settings, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :keyword, null: false
      t.integer :min_price, default: 0, null: false
      t.integer :max_price, default: 0, null: false
      t.boolean :enabled, default: false, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:product_id], name: "index_janpara_crawl_settings_on_product_id"
    end

    create_table :janpara_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id
      t.string :external_id, null: false
      t.string :name, null: false
      t.text :thumbnail_url
      t.integer :price, default: 0, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:external_id], name: "index_janpara_products_on_external_id", unique: true
      t.index [:product_id, :external_id], name: "index_janpara_products_on_product_id_and_external_id", unique: true
      t.index [:product_id], name: "index_janpara_products_on_product_id"
    end

    create_table :janpara_crawl_setting_required_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :janpara_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:janpara_crawl_setting_id, :keyword], name: "idx_on_janpara_crawl_setting_id_keyword_198f4d9655", unique: true
      t.index [:janpara_crawl_setting_id], name: "idx_on_janpara_crawl_setting_id_e721383245"
    end

    create_table :janpara_crawl_setting_exclude_products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :janpara_crawl_setting_id
      t.string :external_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:janpara_crawl_setting_id, :external_id], name: "idx_on_janpara_crawl_setting_id_external_id_102eeb7612", unique: true
      t.index [:janpara_crawl_setting_id], name: "idx_on_janpara_crawl_setting_id_3d622eaffd"
    end

    create_table :janpara_crawl_setting_exclude_keywords, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :janpara_crawl_setting_id
      t.string :keyword, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:janpara_crawl_setting_id, :keyword], name: "idx_on_janpara_crawl_setting_id_keyword_7074a129f7", unique: true
      t.index [:janpara_crawl_setting_id], name: "idx_on_janpara_crawl_setting_id_e7210a8e11"
    end

    add_foreign_key :janpara_crawl_setting_exclude_keywords, :janpara_crawl_settings
    add_foreign_key :janpara_crawl_setting_exclude_products, :janpara_crawl_settings
    add_foreign_key :janpara_crawl_setting_required_keywords, :janpara_crawl_settings
    add_foreign_key :janpara_crawl_settings, :products
    add_foreign_key :janpara_products, :products
  end
end
