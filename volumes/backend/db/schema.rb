# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_03_225609) do
  create_table "calculate_daily_yahoo_auction_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "price"
    t.date "target_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "target_date"], name: "idx_on_product_id_target_date_cf1660df56", unique: true
    t.index ["product_id"], name: "index_calculate_daily_yahoo_auction_products_on_product_id"
  end

  create_table "mercari_crawl_setting_exclude_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "mercari_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mercari_crawl_setting_id"], name: "idx_on_mercari_crawl_setting_id_f56a952474"
  end

  create_table "mercari_crawl_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "keyword", null: false
    t.integer "category_id"
    t.integer "min_price", default: 0, null: false
    t.integer "max_price", default: 0, null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_mercari_crawl_settings_on_product_id"
  end

  create_table "mercari_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "mercari_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.datetime "bought_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mercari_id"], name: "index_mercari_products_on_mercari_id", unique: true
    t.index ["product_id"], name: "index_mercari_products_on_product_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "yahoo_auction_crawl_setting_exclude_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "yahoo_auction_crawl_setting_id"
    t.string "keyword"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["yahoo_auction_crawl_setting_id"], name: "idx_on_yahoo_auction_crawl_setting_id_fb93459e66"
  end

  create_table "yahoo_auction_crawl_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "category_id", default: 0
    t.integer "min_price", default: 0, null: false
    t.integer "max_price", default: 0, null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "keyword", null: false
    t.index ["product_id"], name: "index_yahoo_auction_crawl_settings_on_product_id"
  end

  create_table "yahoo_auction_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "yahoo_auction_id", null: false
    t.string "seller_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.datetime "bought_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_yahoo_auction_products_on_product_id"
    t.index ["yahoo_auction_id"], name: "index_yahoo_auction_products_on_yahoo_auction_id", unique: true
  end

  add_foreign_key "calculate_daily_yahoo_auction_products", "products"
  add_foreign_key "mercari_crawl_setting_exclude_keywords", "mercari_crawl_settings"
  add_foreign_key "mercari_crawl_settings", "products"
  add_foreign_key "mercari_products", "products"
  add_foreign_key "yahoo_auction_crawl_setting_exclude_keywords", "yahoo_auction_crawl_settings"
  add_foreign_key "yahoo_auction_crawl_settings", "products"
  add_foreign_key "yahoo_auction_products", "products"
end
