class CreateProductCategoryMaps < ActiveRecord::Migration[7.1]
  def change
    create_table :product_category_maps do |t|
      t.references :product, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :product_category_maps, %i[product_id category_id], unique: true
  end
end
