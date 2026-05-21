class AllowNullSpecsForBackmarketWatchResults < ActiveRecord::Migration[7.1]
  def change
    change_column_null :backmarket_watch_results, :memory, true
    change_column_null :backmarket_watch_results, :storage, true
    change_column_null :backmarket_watch_results, :cpu, true
  end
end
