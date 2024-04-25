class ChangeUniqueIndexToYahooAuctionProduct < ActiveRecord::Migration[7.1]
  def change
    remove_index :yahoo_auction_products, name: "index_yahoo_auction_products_on_yahoo_auction_id"
    add_index :yahoo_auction_products, %i[product_id yahoo_auction_id], unique: true
  end
end
