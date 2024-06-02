class CreateUsedSofmapCrawlSettingExcludeProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :used_sofmap_crawl_setting_exclude_products do |t|
      t.references :used_sofmap_crawl_setting, foreign_key: true

      t.string :external_id, null: false

      t.timestamps
    end

    add_index :used_sofmap_crawl_setting_exclude_products, %i[used_sofmap_crawl_setting_id external_id], unique: true
  end
end
