class CreateMercariProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :mercari_products do |t|
      t.references :product, foreign_key: true

      t.string :mercari_id, null: false, index: { unique: true }
      t.string :seller_id, null: false
      t.string :name, null: false
      t.text :thumbnail_url, null: true
      t.integer :price, null: false, default: 0
      t.boolean :published, null: false, default: false
      t.datetime :bought_date

      t.timestamps
    end
  end
end
