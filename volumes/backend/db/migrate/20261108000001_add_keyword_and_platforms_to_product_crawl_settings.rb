class AddKeywordAndPlatformsToProductCrawlSettings < ActiveRecord::Migration[8.1]
  def change
    change_table :product_crawl_settings, bulk: true do |t|
      t.string :keyword, after: :enabled
      t.json :platforms, null: false, default: -> { "(json_array())" }, after: :keyword
    end
  end
end
