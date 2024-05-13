class AddUniqueIndexToRequiredKeywords < ActiveRecord::Migration[7.1]
  def change
    add_index :yahoo_auction_crawl_setting_required_keywords, %i[yahoo_auction_crawl_setting_id keyword], unique: true
    add_index :mercari_crawl_setting_required_keywords, %i[mercari_crawl_setting_id keyword], unique: true
    add_index :janpara_crawl_setting_required_keywords, %i[janpara_crawl_setting_id keyword], unique: true
    add_index :iosys_crawl_setting_required_keywords, %i[iosys_crawl_setting_id keyword], unique: true
    add_index :pc_koubou_crawl_setting_required_keywords, %i[pc_koubou_crawl_setting_id keyword], unique: true
  end
end
