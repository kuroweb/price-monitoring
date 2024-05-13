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

ActiveRecord::Schema[7.1].define(version: 2024_05_13_113159) do
  create_table "iosys_crawl_setting_exclude_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "iosys_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iosys_crawl_setting_id", "keyword"], name: "idx_on_iosys_crawl_setting_id_keyword_2429715633", unique: true
    t.index ["iosys_crawl_setting_id"], name: "idx_on_iosys_crawl_setting_id_889c2c2e88"
  end

  create_table "iosys_crawl_setting_required_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "iosys_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iosys_crawl_setting_id", "keyword"], name: "idx_on_iosys_crawl_setting_id_keyword_5beae71d90", unique: true
    t.index ["iosys_crawl_setting_id"], name: "idx_on_iosys_crawl_setting_id_abd2c33544"
  end

  create_table "iosys_crawl_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "keyword", null: false
    t.integer "min_price", default: 0, null: false
    t.integer "max_price", default: 0, null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_iosys_crawl_settings_on_product_id"
  end

  create_table "iosys_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "iosys_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iosys_id"], name: "index_iosys_products_on_iosys_id", unique: true
    t.index ["product_id", "iosys_id"], name: "index_iosys_products_on_product_id_and_iosys_id", unique: true
    t.index ["product_id"], name: "index_iosys_products_on_product_id"
  end

  create_table "janpara_crawl_setting_exclude_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "janpara_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["janpara_crawl_setting_id", "keyword"], name: "idx_on_janpara_crawl_setting_id_keyword_7074a129f7", unique: true
    t.index ["janpara_crawl_setting_id"], name: "idx_on_janpara_crawl_setting_id_e7210a8e11"
  end

  create_table "janpara_crawl_setting_required_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "janpara_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["janpara_crawl_setting_id", "keyword"], name: "idx_on_janpara_crawl_setting_id_keyword_198f4d9655", unique: true
    t.index ["janpara_crawl_setting_id"], name: "idx_on_janpara_crawl_setting_id_e721383245"
  end

  create_table "janpara_crawl_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "keyword", null: false
    t.integer "min_price", default: 0, null: false
    t.integer "max_price", default: 0, null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_janpara_crawl_settings_on_product_id"
  end

  create_table "janpara_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "janpara_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["janpara_id"], name: "index_janpara_products_on_janpara_id", unique: true
    t.index ["product_id", "janpara_id"], name: "index_janpara_products_on_product_id_and_janpara_id", unique: true
    t.index ["product_id"], name: "index_janpara_products_on_product_id"
  end

  create_table "mercari_crawl_setting_exclude_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "mercari_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mercari_crawl_setting_id", "keyword"], name: "idx_on_mercari_crawl_setting_id_keyword_4e4cc0381b", unique: true
    t.index ["mercari_crawl_setting_id"], name: "idx_on_mercari_crawl_setting_id_f56a952474"
  end

  create_table "mercari_crawl_setting_required_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "mercari_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mercari_crawl_setting_id", "keyword"], name: "idx_on_mercari_crawl_setting_id_keyword_cc21910aea", unique: true
    t.index ["mercari_crawl_setting_id"], name: "idx_on_mercari_crawl_setting_id_4659f97e15"
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

  create_table "mercari_daily_purchase_summaries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "average_purchase_price"
    t.integer "purchase_count", default: 0
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "date"], name: "index_mercari_daily_purchase_summaries_on_product_id_and_date", unique: true
    t.index ["product_id"], name: "index_mercari_daily_purchase_summaries_on_product_id"
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
    t.index ["product_id", "mercari_id"], name: "index_mercari_products_on_product_id_and_mercari_id", unique: true
    t.index ["product_id"], name: "index_mercari_products_on_product_id"
  end

  create_table "pc_koubou_crawl_setting_exclude_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "pc_koubou_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pc_koubou_crawl_setting_id", "keyword"], name: "idx_on_pc_koubou_crawl_setting_id_keyword_8c3917f08a", unique: true
    t.index ["pc_koubou_crawl_setting_id"], name: "idx_on_pc_koubou_crawl_setting_id_f8f5317000"
  end

  create_table "pc_koubou_crawl_setting_required_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "pc_koubou_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pc_koubou_crawl_setting_id", "keyword"], name: "idx_on_pc_koubou_crawl_setting_id_keyword_8e3b9acc35", unique: true
    t.index ["pc_koubou_crawl_setting_id"], name: "idx_on_pc_koubou_crawl_setting_id_d2ecc2a271"
  end

  create_table "pc_koubou_crawl_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "keyword", null: false
    t.integer "min_price", default: 0, null: false
    t.integer "max_price", default: 0, null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_pc_koubou_crawl_settings_on_product_id"
  end

  create_table "pc_koubou_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "pc_koubou_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pc_koubou_id"], name: "index_pc_koubou_products_on_pc_koubou_id", unique: true
    t.index ["product_id", "pc_koubou_id"], name: "index_pc_koubou_products_on_product_id_and_pc_koubou_id", unique: true
    t.index ["product_id"], name: "index_pc_koubou_products_on_product_id"
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
    t.index ["yahoo_auction_crawl_setting_id", "keyword"], name: "idx_on_yahoo_auction_crawl_setting_id_keyword_9341e10548", unique: true
    t.index ["yahoo_auction_crawl_setting_id"], name: "idx_on_yahoo_auction_crawl_setting_id_fb93459e66"
  end

  create_table "yahoo_auction_crawl_setting_required_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "yahoo_auction_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["yahoo_auction_crawl_setting_id", "keyword"], name: "idx_on_yahoo_auction_crawl_setting_id_keyword_daee6cea4b", unique: true
    t.index ["yahoo_auction_crawl_setting_id"], name: "idx_on_yahoo_auction_crawl_setting_id_49589afeb2"
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

  create_table "yahoo_auction_daily_purchase_summaries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "average_purchase_price"
    t.integer "purchase_count", default: 0
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "date"], name: "idx_on_product_id_date_d63712c38b", unique: true
    t.index ["product_id"], name: "index_yahoo_auction_daily_purchase_summaries_on_product_id"
  end

  create_table "yahoo_auction_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "yahoo_auction_id", null: false
    t.string "seller_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.integer "buyout_price"
    t.boolean "published", default: false, null: false
    t.datetime "bought_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "yahoo_auction_id"], name: "idx_on_product_id_yahoo_auction_id_770761a83e", unique: true
    t.index ["product_id"], name: "index_yahoo_auction_products_on_product_id"
  end

  create_table "yahoo_fleamarket_daily_purchase_summaries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "average_purchase_price"
    t.integer "purchase_count", default: 0
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "date"], name: "idx_on_product_id_date_bd09f0e249", unique: true
    t.index ["product_id"], name: "index_yahoo_fleamarket_daily_purchase_summaries_on_product_id"
  end

  create_table "yahoo_fleamarket_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "yahoo_fleamarket_id", null: false
    t.string "seller_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.datetime "bought_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "yahoo_fleamarket_id"], name: "idx_on_product_id_yahoo_fleamarket_id_2d476d7a24", unique: true
    t.index ["product_id"], name: "index_yahoo_fleamarket_products_on_product_id"
  end

  add_foreign_key "iosys_crawl_setting_exclude_keywords", "iosys_crawl_settings"
  add_foreign_key "iosys_crawl_setting_required_keywords", "iosys_crawl_settings"
  add_foreign_key "iosys_crawl_settings", "products"
  add_foreign_key "iosys_products", "products"
  add_foreign_key "janpara_crawl_setting_exclude_keywords", "janpara_crawl_settings"
  add_foreign_key "janpara_crawl_setting_required_keywords", "janpara_crawl_settings"
  add_foreign_key "janpara_crawl_settings", "products"
  add_foreign_key "janpara_products", "products"
  add_foreign_key "mercari_crawl_setting_exclude_keywords", "mercari_crawl_settings"
  add_foreign_key "mercari_crawl_setting_required_keywords", "mercari_crawl_settings"
  add_foreign_key "mercari_crawl_settings", "products"
  add_foreign_key "mercari_daily_purchase_summaries", "products"
  add_foreign_key "mercari_products", "products"
  add_foreign_key "pc_koubou_crawl_setting_exclude_keywords", "pc_koubou_crawl_settings"
  add_foreign_key "pc_koubou_crawl_setting_required_keywords", "pc_koubou_crawl_settings"
  add_foreign_key "pc_koubou_crawl_settings", "products"
  add_foreign_key "pc_koubou_products", "products"
  add_foreign_key "yahoo_auction_crawl_setting_exclude_keywords", "yahoo_auction_crawl_settings"
  add_foreign_key "yahoo_auction_crawl_setting_required_keywords", "yahoo_auction_crawl_settings"
  add_foreign_key "yahoo_auction_crawl_settings", "products"
  add_foreign_key "yahoo_auction_daily_purchase_summaries", "products"
  add_foreign_key "yahoo_auction_products", "products"
  add_foreign_key "yahoo_fleamarket_daily_purchase_summaries", "products"
  add_foreign_key "yahoo_fleamarket_products", "products"
end
