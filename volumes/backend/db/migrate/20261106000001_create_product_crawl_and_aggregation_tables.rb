class CreateProductCrawlAndAggregationTables < ActiveRecord::Migration[8.1]
  def change
    create_table :product_crawl_settings do |t|
      t.string :name, null: false
      t.boolean :enabled, null: false, default: false
      t.json :search_urls, null: false, default: -> { "(json_array())" }
      t.json :required_keywords, null: false, default: -> { "(json_array())" }
      t.json :exclude_keywords, null: false, default: -> { "(json_array())" }
      t.json :exclude_external_ids, null: false, default: -> { "(json_array())" }
      t.integer :min_price, null: true
      t.integer :max_price, null: true

      t.timestamps
    end

    create_table :product_crawl_results do |t|
      t.references :product_crawl_setting, null: false, foreign_key: true
      t.string :platform, null: false
      t.string :external_id, null: false
      t.string :name, null: false
      t.text :product_url, null: false
      t.text :thumbnail_url, null: true
      t.integer :price, null: false, default: 0
      t.integer :buyout_price, null: true
      t.boolean :sold, null: true
      t.datetime :bought_date, null: true
      t.datetime :end_date, null: true

      t.timestamps
    end

    add_index :product_crawl_results, %i[product_crawl_setting_id external_id], unique: true
    add_index :product_crawl_results, :external_id

    create_table :product_aggregation_settings do |t|
      t.string :name, null: false
      t.json :required_keywords, null: false, default: -> { "(json_array())" }
      t.json :exclude_keywords, null: false, default: -> { "(json_array())" }
      t.integer :min_price, null: true
      t.integer :max_price, null: true

      t.timestamps
    end

    create_table :product_aggregation_results do |t|
      t.references :product_aggregation_setting, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :average_purchase_price, null: true
      t.integer :purchase_count, null: false, default: 0

      t.timestamps
    end

    add_index :product_aggregation_results, %i[product_aggregation_setting_id date], unique: true
  end
end
