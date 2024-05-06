class CreatePcKoubouCrawlSettingExcludeKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :pc_koubou_crawl_setting_exclude_keywords do |t|
      t.references :pc_koubou_crawl_setting, foreign_key: true

      t.string :keyword, null: false

      t.timestamps
    end
  end
end
