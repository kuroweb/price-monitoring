class CreateCrawlHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :crawl_histories do |t|
      t.references :product, index: true

      t.text :html

      t.timestamps
    end
  end
end
