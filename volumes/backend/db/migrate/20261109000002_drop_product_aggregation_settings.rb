class DropProductAggregationSettings < ActiveRecord::Migration[8.1]
  def change
    drop_table :product_aggregation_settings do |t|
      t.string :name, null: false
      t.json :required_keywords, null: false, default: -> { "(json_array())" }
      t.json :exclude_keywords, null: false, default: -> { "(json_array())" }
      t.integer :min_price
      t.integer :max_price
      t.timestamps
    end
  end
end
