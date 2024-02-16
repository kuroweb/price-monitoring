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

ActiveRecord::Schema[7.1].define(version: 2024_02_16_213455) do
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

  create_table "yahoo_auction_crawl_setting_exclude_conditions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "yahoo_auction_crawl_setting_id"
    t.string "keyword"
    t.string "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["yahoo_auction_crawl_setting_id"], name: "idx_on_yahoo_auction_crawl_setting_id_f5bceade03"
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
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "bought_date"
    t.index ["product_id"], name: "index_yahoo_auction_products_on_product_id"
    t.index ["yahoo_auction_id"], name: "index_yahoo_auction_products_on_yahoo_auction_id", unique: true
  end

  add_foreign_key "yahoo_auction_crawl_setting_exclude_conditions", "yahoo_auction_crawl_settings"
  add_foreign_key "yahoo_auction_crawl_settings", "products"
  add_foreign_key "yahoo_auction_products", "products"
end
