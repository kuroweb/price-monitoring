class CreatePriceVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :price_versions do |t|
      t.references :product, index: true
      t.references :crawl_history, index: true

      t.integer :price

      t.timestamps
    end
  end
end
