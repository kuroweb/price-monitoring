class ChangeUniqueIndexToYahooFleamarketProduct < ActiveRecord::Migration[7.1]
  def change
    remove_index :yahoo_fleamarket_products, name: "index_yahoo_fleamarket_products_on_yahoo_fleamarket_id"
    add_index :yahoo_fleamarket_products, %i[product_id yahoo_fleamarket_id], unique: true
  end
end
