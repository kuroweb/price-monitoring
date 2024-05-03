class CreateIosysProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :iosys_products do |t|
      t.references :product, foreign_key: true

      t.string :iosys_id, null: false, index: { unique: true }
      t.string :name, null: false
      t.text :thumbnail_url, null: true
      t.integer :price, null: false, default: 0

      t.timestamps
    end

    add_index :iosys_products, %i[product_id iosys_id], unique: true
  end
end
