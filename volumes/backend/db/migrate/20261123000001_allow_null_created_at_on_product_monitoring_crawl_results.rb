class AllowNullCreatedAtOnProductMonitoringCrawlResults < ActiveRecord::Migration[8.1]
  def change
    change_column_null :product_monitoring_crawl_results, :created_at, true
  end
end
