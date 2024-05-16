class ChangeExternalIdColumns < ActiveRecord::Migration[7.1]
  def change
    rename_column :yahoo_auction_products, :yahoo_auction_id, :external_id
    rename_column :yahoo_fleamarket_products, :yahoo_fleamarket_id, :external_id
    rename_column :mercari_products, :mercari_id, :external_id
    rename_column :janpara_products, :janpara_id, :external_id
    rename_column :iosys_products, :iosys_id, :external_id
    rename_column :pc_koubou_products, :pc_koubou_id, :external_id
  end
end
