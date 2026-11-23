class AddPriceAndIdIndexToProductMonitoringCrawlResults < ActiveRecord::Migration[8.1]
  def change
    add_index :product_monitoring_crawl_results, %i[price id],
              order: { id: :desc },
              name: "index_product_monitoring_crawl_results_on_price_and_id"
  end
end
