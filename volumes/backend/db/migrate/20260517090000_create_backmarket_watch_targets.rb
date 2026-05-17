class CreateBackmarketWatchTargets < ActiveRecord::Migration[7.1]
  def change
    create_table :backmarket_watch_targets do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end
  end
end
