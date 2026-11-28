class AddSellerIdToProductMonitoringCrawlResults < ActiveRecord::Migration[8.1]
  def change
    # 出品者IDはサイト内で大文字小文字まで区別して照合するので、照合順序を utf8mb4_bin にする
    add_column :product_monitoring_crawl_results, :seller_id, :string, collation: "utf8mb4_bin"
    add_index :product_monitoring_crawl_results, %i[platform seller_id]
  end
end
