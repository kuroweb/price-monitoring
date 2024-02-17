class AddBoughtDateColumnToYahooAuctionProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :yahoo_auction_products, :bought_date, :datetime, null: true, default: nil, after: :published
  end
end
