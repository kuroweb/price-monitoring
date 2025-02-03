class AddHiddenColumnToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :yahoo_auction_products, :hidden, :boolean, default: false, after: :end_date
    add_column :yahoo_fleamarket_products, :hidden, :boolean, default: false, after: :bought_date
    add_column :mercari_products, :hidden, :boolean, default: false, after: :bought_date
    add_column :iosys_products, :hidden, :boolean, default: false, after: :price
    add_column :janpara_products, :hidden, :boolean, default: false, after: :price
    add_column :pc_koubou_products, :hidden, :boolean, default: false, after: :price
    add_column :used_sofmap_products, :hidden, :boolean, default: false, after: :price
  end
end
