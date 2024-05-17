class CreateJanparaCrawlSettingExcludeProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :janpara_crawl_setting_exclude_products do |t|
      t.references :janpara_crawl_setting, foreign_key: true

      t.string :external_id, null: false

      t.timestamps
    end

    add_index :janpara_crawl_setting_exclude_products, %i[janpara_crawl_setting_id external_id], unique: true
  end
end
