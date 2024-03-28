class CreateMercariCrawlSettingRequiredKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :mercari_crawl_setting_required_keywords do |t|
      t.references :mercari_crawl_setting, foreign_key: true

      t.string :keyword, null: false

      t.timestamps
    end
  end
end
