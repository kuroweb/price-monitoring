class AddBidInformationColumnsToYahooAuctionProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :yahoo_auction_products, :buyout_price, :int, null: true, default: nil, after: :price
    add_column :yahoo_auction_products, :end_date, :datetime, null: true, default: nil, after: :bought_date
  end
end
