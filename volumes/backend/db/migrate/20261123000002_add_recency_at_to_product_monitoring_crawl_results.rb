class AddRecencyAtToProductMonitoringCrawlResults < ActiveRecord::Migration[8.1]
  def up
    add_column :product_monitoring_crawl_results, :recency_at, :datetime
    # 売り切れで売れた日がある行はその日、売れた日がない売り切れは空、それ以外は初回保存時刻
    execute <<~SQL.squish
      UPDATE product_monitoring_crawl_results
      SET recency_at = CASE
        WHEN sold = 1 AND sold_at IS NOT NULL THEN sold_at
        WHEN sold = 1 THEN NULL
        ELSE created_at
      END
    SQL
    add_index :product_monitoring_crawl_results, :recency_at,
              name: "index_product_monitoring_crawl_results_on_recency_at"
  end

  def down
    change_table :product_monitoring_crawl_results, bulk: true do |t|
      t.remove_index name: "index_product_monitoring_crawl_results_on_recency_at"
      t.remove :recency_at
    end
  end
end
