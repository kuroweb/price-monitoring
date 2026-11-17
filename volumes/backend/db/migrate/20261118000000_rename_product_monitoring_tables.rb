class RenameProductMonitoringTables < ActiveRecord::Migration[8.0]
  def change
    rename_table :product_crawl_settings, :product_monitoring_crawl_settings
    rename_table :product_crawl_results, :product_monitoring_crawl_results
    rename_table :product_watch_settings, :product_monitoring_monitors
    rename_table :product_aggregation_results, :product_monitoring_daily_market_prices

    # rubocop:disable Rails/BulkChangeTable
    rename_column :product_monitoring_crawl_settings, :keyword, :search_keyword
    rename_column :product_monitoring_crawl_settings, :exclude_keywords, :negative_keywords
    rename_column :product_monitoring_crawl_results, :product_crawl_setting_id, :crawl_setting_id
    rename_column :product_monitoring_crawl_results, :bought_date, :sold_at
    rename_column :product_monitoring_crawl_results, :end_date, :ends_at
    rename_column :product_monitoring_monitors, :exclude_keywords, :negative_keywords
    rename_column :product_monitoring_daily_market_prices, :product_watch_setting_id, :monitor_id
    rename_column :product_monitoring_daily_market_prices, :average_purchase_price, :average_transaction_price
    rename_column :product_monitoring_daily_market_prices, :purchase_count, :transaction_count

    # rubocop:enable Rails/BulkChangeTable
    rename_index :product_monitoring_crawl_results, :index_product_crawl_results_on_lowest_price,
                 :idx_monitoring_crawl_results_lowest_price
  end
end
