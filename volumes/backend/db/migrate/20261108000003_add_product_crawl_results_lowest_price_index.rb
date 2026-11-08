class AddProductCrawlResultsLowestPriceIndex < ActiveRecord::Migration[8.1]
  def change
    add_index :product_crawl_results, %i[sold excluded_at price id], name: "index_product_crawl_results_on_lowest_price"
  end
end
