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

ActiveRecord::Schema[7.1].define(version: 2024_06_24_001708) do
  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "category_hierarchies", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "category_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "category_desc_idx"
  end

  create_table "iosys_crawl_setting_exclude_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "iosys_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iosys_crawl_setting_id", "keyword"], name: "idx_on_iosys_crawl_setting_id_keyword_2429715633", unique: true
    t.index ["iosys_crawl_setting_id"], name: "idx_on_iosys_crawl_setting_id_889c2c2e88"
  end

  create_table "iosys_crawl_setting_exclude_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "iosys_crawl_setting_id"
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iosys_crawl_setting_id", "external_id"], name: "idx_on_iosys_crawl_setting_id_external_id_b0528c956e", unique: true
    t.index ["iosys_crawl_setting_id"], name: "idx_on_iosys_crawl_setting_id_180f55a37c"
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
    t.string "external_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_iosys_products_on_external_id", unique: true
    t.index ["product_id", "external_id"], name: "index_iosys_products_on_product_id_and_external_id", unique: true
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

  create_table "janpara_crawl_setting_exclude_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "janpara_crawl_setting_id"
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["janpara_crawl_setting_id", "external_id"], name: "idx_on_janpara_crawl_setting_id_external_id_102eeb7612", unique: true
    t.index ["janpara_crawl_setting_id"], name: "idx_on_janpara_crawl_setting_id_3d622eaffd"
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
    t.string "external_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_janpara_products_on_external_id", unique: true
    t.index ["product_id", "external_id"], name: "index_janpara_products_on_product_id_and_external_id", unique: true
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

  create_table "mercari_crawl_setting_exclude_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "mercari_crawl_setting_id"
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mercari_crawl_setting_id", "external_id"], name: "idx_on_mercari_crawl_setting_id_external_id_34002464be", unique: true
    t.index ["mercari_crawl_setting_id"], name: "idx_on_mercari_crawl_setting_id_22de934ea6"
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
    t.string "external_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.datetime "bought_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "external_id"], name: "index_mercari_products_on_product_id_and_external_id", unique: true
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

  create_table "pc_koubou_crawl_setting_exclude_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "pc_koubou_crawl_setting_id"
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pc_koubou_crawl_setting_id", "external_id"], name: "idx_on_pc_koubou_crawl_setting_id_external_id_96823e00f8", unique: true
    t.index ["pc_koubou_crawl_setting_id"], name: "idx_on_pc_koubou_crawl_setting_id_8b1b1a24af"
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
    t.string "external_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_pc_koubou_products_on_external_id", unique: true
    t.index ["product_id", "external_id"], name: "index_pc_koubou_products_on_product_id_and_external_id", unique: true
    t.index ["product_id"], name: "index_pc_koubou_products_on_product_id"
  end

  create_table "product_category_maps", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_category_maps_on_category_id"
    t.index ["product_id", "category_id"], name: "index_product_category_maps_on_product_id_and_category_id", unique: true
    t.index ["product_id"], name: "index_product_category_maps_on_product_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "used_sofmap_crawl_setting_exclude_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "used_sofmap_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["used_sofmap_crawl_setting_id", "keyword"], name: "idx_on_used_sofmap_crawl_setting_id_keyword_7475198f68", unique: true
    t.index ["used_sofmap_crawl_setting_id"], name: "idx_on_used_sofmap_crawl_setting_id_7f42917bfe"
  end

  create_table "used_sofmap_crawl_setting_exclude_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "used_sofmap_crawl_setting_id"
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["used_sofmap_crawl_setting_id", "external_id"], name: "idx_on_used_sofmap_crawl_setting_id_external_id_d8c3f14b71", unique: true
    t.index ["used_sofmap_crawl_setting_id"], name: "idx_on_used_sofmap_crawl_setting_id_516fe376cb"
  end

  create_table "used_sofmap_crawl_setting_required_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "used_sofmap_crawl_setting_id"
    t.string "keyword", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["used_sofmap_crawl_setting_id", "keyword"], name: "idx_on_used_sofmap_crawl_setting_id_keyword_7296d7cbc9", unique: true
    t.index ["used_sofmap_crawl_setting_id"], name: "idx_on_used_sofmap_crawl_setting_id_57a4411deb"
  end

  create_table "used_sofmap_crawl_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "keyword", null: false
    t.integer "min_price", default: 0, null: false
    t.integer "max_price", default: 0, null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_used_sofmap_crawl_settings_on_product_id"
  end

  create_table "used_sofmap_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.string "external_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_used_sofmap_products_on_external_id", unique: true
    t.index ["product_id", "external_id"], name: "index_used_sofmap_products_on_product_id_and_external_id", unique: true
    t.index ["product_id"], name: "index_used_sofmap_products_on_product_id"
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

  create_table "yahoo_auction_crawl_setting_exclude_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "yahoo_auction_crawl_setting_id"
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["yahoo_auction_crawl_setting_id", "external_id"], name: "idx_on_yahoo_auction_crawl_setting_id_external_id_c904750663", unique: true
    t.index ["yahoo_auction_crawl_setting_id"], name: "idx_on_yahoo_auction_crawl_setting_id_b30a20343c"
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
    t.string "external_id", null: false
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
    t.index ["product_id", "external_id"], name: "index_yahoo_auction_products_on_product_id_and_external_id", unique: true
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
    t.string "external_id", null: false
    t.string "seller_id", null: false
    t.string "name", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.datetime "bought_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "external_id"], name: "index_yahoo_fleamarket_products_on_product_id_and_external_id", unique: true
    t.index ["product_id"], name: "index_yahoo_fleamarket_products_on_product_id"
  end

  add_foreign_key "iosys_crawl_setting_exclude_keywords", "iosys_crawl_settings"
  add_foreign_key "iosys_crawl_setting_exclude_products", "iosys_crawl_settings"
  add_foreign_key "iosys_crawl_setting_required_keywords", "iosys_crawl_settings"
  add_foreign_key "iosys_crawl_settings", "products"
  add_foreign_key "iosys_products", "products"
  add_foreign_key "janpara_crawl_setting_exclude_keywords", "janpara_crawl_settings"
  add_foreign_key "janpara_crawl_setting_exclude_products", "janpara_crawl_settings"
  add_foreign_key "janpara_crawl_setting_required_keywords", "janpara_crawl_settings"
  add_foreign_key "janpara_crawl_settings", "products"
  add_foreign_key "janpara_products", "products"
  add_foreign_key "mercari_crawl_setting_exclude_keywords", "mercari_crawl_settings"
  add_foreign_key "mercari_crawl_setting_exclude_products", "mercari_crawl_settings"
  add_foreign_key "mercari_crawl_setting_required_keywords", "mercari_crawl_settings"
  add_foreign_key "mercari_crawl_settings", "products"
  add_foreign_key "mercari_daily_purchase_summaries", "products"
  add_foreign_key "mercari_products", "products"
  add_foreign_key "pc_koubou_crawl_setting_exclude_keywords", "pc_koubou_crawl_settings"
  add_foreign_key "pc_koubou_crawl_setting_exclude_products", "pc_koubou_crawl_settings"
  add_foreign_key "pc_koubou_crawl_setting_required_keywords", "pc_koubou_crawl_settings"
  add_foreign_key "pc_koubou_crawl_settings", "products"
  add_foreign_key "pc_koubou_products", "products"
  add_foreign_key "product_category_maps", "categories"
  add_foreign_key "product_category_maps", "products"
  add_foreign_key "used_sofmap_crawl_setting_exclude_keywords", "used_sofmap_crawl_settings"
  add_foreign_key "used_sofmap_crawl_setting_exclude_products", "used_sofmap_crawl_settings"
  add_foreign_key "used_sofmap_crawl_setting_required_keywords", "used_sofmap_crawl_settings"
  add_foreign_key "used_sofmap_crawl_settings", "products"
  add_foreign_key "used_sofmap_products", "products"
  add_foreign_key "yahoo_auction_crawl_setting_exclude_keywords", "yahoo_auction_crawl_settings"
  add_foreign_key "yahoo_auction_crawl_setting_exclude_products", "yahoo_auction_crawl_settings"
  add_foreign_key "yahoo_auction_crawl_setting_required_keywords", "yahoo_auction_crawl_settings"
  add_foreign_key "yahoo_auction_crawl_settings", "products"
  add_foreign_key "yahoo_auction_daily_purchase_summaries", "products"
  add_foreign_key "yahoo_auction_products", "products"
  add_foreign_key "yahoo_fleamarket_daily_purchase_summaries", "products"
  add_foreign_key "yahoo_fleamarket_products", "products"
end
