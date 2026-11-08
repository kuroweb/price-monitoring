class AddKeywordAndPlatformsToProductCrawlSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :product_crawl_settings, :keyword, :string, after: :enabled
    add_column :product_crawl_settings, :platforms, :json, null: false, default: -> { "(json_array())" }, after: :keyword
  end
end
