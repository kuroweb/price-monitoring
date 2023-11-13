class CreateCrawlSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :crawl_settings do |t|
      t.references :product, index: true

      t.integer :interval
      t.boolean :enabled

      t.timestamps
    end
  end
end
