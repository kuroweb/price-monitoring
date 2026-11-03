class AddSearchSettingsToProducts < ActiveRecord::Migration[7.1]
  def change
    change_table :products, bulk: true do |t|
      t.boolean :enabled, null: false, default: false
      t.integer :min_price
      t.integer :max_price
    end
    create_table :product_search_urls do |t|
      t.references :product, null: false, foreign_key: true
      t.text :url, null: false
      t.boolean :enabled, null: false, default: true
      t.timestamps
    end
    { product_required_keywords: :keyword, product_exclude_keywords: :keyword }.each do |table, column|
      create_table table do |t|
        t.references :product, null: false, foreign_key: true
        t.string column, null: false
        t.timestamps
      end
      add_index table, %i[product_id keyword], unique: true
    end
    create_table :product_excluded_listings do |t|
      t.references :product, null: false, foreign_key: true
      t.string :platform, null: false
      t.string :external_id, null: false
      t.timestamps
    end
    add_index :product_excluded_listings, %i[product_id platform external_id], unique: true
  end
end
