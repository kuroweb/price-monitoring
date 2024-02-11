class AddCanceledColumnToYahooAuctionProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :yahoo_auction_products, :canceled, :boolean, null: false, default: false
  end
end
