class AddRecencyAtAndIdIndexToProductMonitoringCrawlResults < ActiveRecord::Migration[8.1]
  def change
    add_index :product_monitoring_crawl_results, %i[recency_at id],
              order: { recency_at: :desc, id: :desc },
              name: "index_product_monitoring_crawl_results_on_recency_at_and_id"
  end
end
