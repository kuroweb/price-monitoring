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

ActiveRecord::Schema[8.1].define(version: 2026_11_25_000002) do
  create_table "backmarket_watch_results", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "backmarket_watch_target_id", null: false
    t.string "name", null: false
    t.integer "price"
    t.string "condition"
    t.string "memory"
    t.string "storage"
    t.string "cpu"
    t.string "stock_status", null: false
    t.datetime "crawled_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["backmarket_watch_target_id", "crawled_at"], name: "idx_on_backmarket_watch_target_id_crawled_at_47ae23aa26"
    t.index ["backmarket_watch_target_id"], name: "index_backmarket_watch_results_on_backmarket_watch_target_id"
  end

  create_table "backmarket_watch_targets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_monitoring_crawl_results", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "crawl_setting_id", null: false
    t.string "platform", null: false
    t.string "external_id", null: false
    t.string "name", null: false
    t.text "product_url", null: false
    t.text "thumbnail_url"
    t.integer "price", default: 0, null: false
    t.integer "buyout_price"
    t.boolean "sold"
    t.datetime "sold_at"
    t.datetime "ends_at"
    t.datetime "excluded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "recency_at"
    t.index ["crawl_setting_id", "external_id"], name: "idx_on_crawl_setting_id_external_id_a6fd3476b8", unique: true
    t.index ["crawl_setting_id"], name: "index_product_monitoring_crawl_results_on_crawl_setting_id"
    t.index ["created_at"], name: "index_product_monitoring_crawl_results_on_created_at"
    t.index ["external_id"], name: "index_product_monitoring_crawl_results_on_external_id"
    t.index ["price", "id"], name: "idx_product_monitoring_crawl_results_price_id_desc", order: :desc
    t.index ["price", "id"], name: "index_product_monitoring_crawl_results_on_price_and_id", order: { id: :desc }
    t.index ["recency_at", "id"], name: "index_product_monitoring_crawl_results_on_recency_at_and_id", order: :desc
    t.index ["recency_at"], name: "index_product_monitoring_crawl_results_on_recency_at"
    t.index ["sold", "excluded_at", "price", "id"], name: "idx_monitoring_crawl_results_lowest_price"
  end

  create_table "product_monitoring_crawl_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "enabled", default: false, null: false
    t.string "search_keyword"
    t.json "platforms", default: -> { "(json_array())" }, null: false
    t.json "search_urls", default: -> { "(json_array())" }, null: false
    t.json "required_keywords", default: -> { "(json_array())" }, null: false
    t.json "negative_keywords", default: -> { "(json_array())" }, null: false
    t.integer "min_price"
    t.integer "max_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_monitoring_daily_market_prices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date", null: false
    t.integer "average_transaction_price"
    t.integer "transaction_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "monitor_id", null: false
    t.index ["monitor_id", "date"], name: "idx_on_monitor_id_date_df939332ac", unique: true
    t.index ["monitor_id"], name: "index_product_monitoring_daily_market_prices_on_monitor_id"
  end

  create_table "product_monitoring_monitors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "enabled", default: false, null: false
    t.boolean "discord_enabled", default: false, null: false
    t.json "required_keywords", default: -> { "(json_array())" }, null: false
    t.json "negative_keywords", default: -> { "(json_array())" }, null: false
    t.integer "min_price"
    t.integer "max_price"
    t.string "last_lowest_signature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "newest_notification_enabled", default: false, null: false
    t.datetime "newest_notified_until"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "provider_name", default: "", null: false
    t.string "provider_uid", default: "", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["provider_name", "provider_uid"], name: "index_users_on_provider_name_and_provider_uid", unique: true
  end

  add_foreign_key "backmarket_watch_results", "backmarket_watch_targets"
  add_foreign_key "product_monitoring_crawl_results", "product_monitoring_crawl_settings", column: "crawl_setting_id"
  add_foreign_key "product_monitoring_daily_market_prices", "product_monitoring_monitors", column: "monitor_id"
end
