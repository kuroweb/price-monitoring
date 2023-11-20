class CreateYahooAuctionProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :yahoo_auction_products do |t|
      t.references :product, foreign_key: true

      t.string :name, null: false
      t.text :thumbnail_url, null: true
      t.string :yahoo_auction_id, null: false
      t.integer :price, null: false, default: 0
      t.boolean :published, null: false, default: false

      t.timestamps
    end
  end
end
