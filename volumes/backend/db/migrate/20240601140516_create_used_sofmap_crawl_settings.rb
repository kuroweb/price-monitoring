class CreateUsedSofmapCrawlSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :used_sofmap_crawl_settings do |t|
      t.references :product, foreign_key: true

      t.string "keyword", null: false
      t.integer "min_price", default: 0, null: false
      t.integer "max_price", default: 0, null: false
      t.boolean "enabled", default: false, null: false

      t.timestamps
    end
  end
end
