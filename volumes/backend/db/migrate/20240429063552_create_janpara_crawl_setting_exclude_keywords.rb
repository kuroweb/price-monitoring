class CreateJanparaCrawlSettingExcludeKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :janpara_crawl_setting_exclude_keywords do |t|
      t.references :janpara_crawl_setting, foreign_key: true

      t.string :keyword, null: false

      t.timestamps
    end
  end
end
