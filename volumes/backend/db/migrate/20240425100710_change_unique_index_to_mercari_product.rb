class ChangeUniqueIndexToMercariProduct < ActiveRecord::Migration[7.1]
  def change
    remove_index :mercari_products, name: "index_mercari_products_on_mercari_id"
    add_index :mercari_products, %i[product_id mercari_id], unique: true
  end
end
