class AddUniqueIndexToCalculateDailyYahooAuctionProduct < ActiveRecord::Migration[7.1]
  def change
    add_index :calculate_daily_yahoo_auction_products, %i[product_id target_date], unique: true
  end
end
