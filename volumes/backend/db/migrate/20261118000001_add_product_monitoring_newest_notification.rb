class AddProductMonitoringNewestNotification < ActiveRecord::Migration[8.1]
  def change
    change_table :product_monitoring_monitors, bulk: true do |t|
      t.boolean :newest_notification_enabled, default: false, null: false
      t.datetime :newest_notified_until
    end
    add_index :product_monitoring_crawl_results, :created_at
  end
end
