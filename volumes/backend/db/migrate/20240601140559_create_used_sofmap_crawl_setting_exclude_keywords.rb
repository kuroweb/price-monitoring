class CreateUsedSofmapCrawlSettingExcludeKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :used_sofmap_crawl_setting_exclude_keywords do |t|
      t.references :used_sofmap_crawl_setting, foreign_key: true

      t.string :keyword, null: false

      t.timestamps
    end

    add_index :used_sofmap_crawl_setting_exclude_keywords, %i[used_sofmap_crawl_setting_id keyword], unique: true
  end
end
