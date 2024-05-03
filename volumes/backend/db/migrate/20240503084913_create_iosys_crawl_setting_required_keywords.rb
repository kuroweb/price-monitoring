class CreateIosysCrawlSettingRequiredKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :iosys_crawl_setting_required_keywords do |t|
      t.references :iosys_crawl_setting, foreign_key: true

      t.string :keyword, null: false

      t.timestamps
    end
  end
end
