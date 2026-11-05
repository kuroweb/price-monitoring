# 除外した出品の名前・商品ページ・画像を残すため、除外を結果の行の印に移す
class MoveExclusionsToProductCrawlResults < ActiveRecord::Migration[8.1]
  def change
    add_column :product_crawl_results, :excluded_at, :datetime, null: true, after: :end_date
    remove_column :product_crawl_settings, :exclude_external_ids, :json, null: false, default: -> { "(json_array())" }
  end
end
