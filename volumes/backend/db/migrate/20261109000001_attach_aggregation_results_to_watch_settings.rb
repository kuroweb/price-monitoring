class AttachAggregationResultsToWatchSettings < ActiveRecord::Migration[8.1]
  def up
    execute "DELETE FROM product_aggregation_results"
    remove_index :product_aggregation_results, %i[product_aggregation_setting_id date]
    remove_reference :product_aggregation_results, :product_aggregation_setting, foreign_key: true, index: false
    add_reference :product_aggregation_results, :product_watch_setting, null: false, foreign_key: true # rubocop:disable Rails/NotNullColumn
    add_index :product_aggregation_results, %i[product_watch_setting_id date], unique: true
    execute "UPDATE product_watch_settings SET last_lowest_signature = NULL"
  end

  def down
    execute "DELETE FROM product_aggregation_results"
    remove_index :product_aggregation_results, %i[product_watch_setting_id date]
    remove_reference :product_aggregation_results, :product_watch_setting, foreign_key: true
    add_reference :product_aggregation_results, :product_aggregation_setting, null: false, foreign_key: true # rubocop:disable Rails/NotNullColumn
    add_index :product_aggregation_results, %i[product_aggregation_setting_id date], unique: true
  end
end
