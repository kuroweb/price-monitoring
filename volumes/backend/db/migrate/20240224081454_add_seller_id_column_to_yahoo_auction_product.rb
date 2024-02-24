class AddSellerIdColumnToYahooAuctionProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :yahoo_auction_products, :seller_id, :string, null: false, after: :yahoo_auction_id
  end
end
