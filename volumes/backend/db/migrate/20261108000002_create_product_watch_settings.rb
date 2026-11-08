class CreateProductWatchSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :product_watch_settings do |t|
      t.string :name, null: false
      t.boolean :enabled, null: false, default: false
      t.boolean :discord_enabled, null: false, default: false
      t.json :required_keywords, null: false, default: -> { "(json_array())" }
      t.json :exclude_keywords, null: false, default: -> { "(json_array())" }
      t.integer :min_price
      t.integer :max_price
      t.string :last_lowest_signature
      t.timestamps
    end
  end
end
