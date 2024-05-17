class CreatePcKoubouCrawlSettingExcludeProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :pc_koubou_crawl_setting_exclude_products do |t|
      t.references :pc_koubou_crawl_setting, foreign_key: true

      t.string :external_id, null: false

      t.timestamps
    end

    add_index :pc_koubou_crawl_setting_exclude_products, %i[pc_koubou_crawl_setting_id external_id], unique: true
  end
end
