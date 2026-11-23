class AddDescendingPriceAndIdIndexToProductMonitoringCrawlResults < ActiveRecord::Migration[8.1]
  def change
    add_index :product_monitoring_crawl_results, %i[price id],
              order: { price: :desc, id: :desc },
              name: "idx_product_monitoring_crawl_results_price_id_desc"
  end
end
