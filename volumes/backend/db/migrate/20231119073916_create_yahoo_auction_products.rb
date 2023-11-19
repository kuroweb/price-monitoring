class CreateYahooAuctionProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :yahoo_auction_products do |t|
      t.references :product, index: true

      t.integer :yahoo_auction_id, null: false
      t.string :name, null: false
      t.boolean :published, null: false, default: false

      t.timestamps
    end
  end
end
