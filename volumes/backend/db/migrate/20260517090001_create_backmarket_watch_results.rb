class CreateBackmarketWatchResults < ActiveRecord::Migration[7.1]
  def change
    create_table :backmarket_watch_results do |t|
      t.references :backmarket_watch_target, null: false, foreign_key: true

      t.string :name, null: false
      t.integer :price, null: true
      t.string :condition, null: true
      t.string :memory, null: false
      t.string :storage, null: false
      t.string :cpu, null: false
      t.string :stock_status, null: false
      t.datetime :crawled_at, null: false

      t.timestamps
    end

    add_index :backmarket_watch_results,
              %i[backmarket_watch_target_id crawled_at]
  end
end
