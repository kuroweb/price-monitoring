class DropLegacyProductMeasurement < ActiveRecord::Migration[8.1]
  # 旧商品計測とカテゴリだけが使うテーブル。商品モニタリングと Backmarket のテーブルは対象外。
  LEGACY_TABLES = %w[
    iosys_crawl_setting_exclude_keywords
    iosys_crawl_setting_exclude_products
    iosys_crawl_setting_required_keywords
    iosys_products
    janpara_crawl_setting_exclude_keywords
    janpara_crawl_setting_exclude_products
    janpara_crawl_setting_required_keywords
    janpara_products
    mercari_crawl_setting_exclude_keywords
    mercari_crawl_setting_exclude_products
    mercari_crawl_setting_required_keywords
    mercari_daily_purchase_summaries
    mercari_products
    pc_koubou_crawl_setting_exclude_keywords
    pc_koubou_crawl_setting_exclude_products
    pc_koubou_crawl_setting_required_keywords
    pc_koubou_products
    used_sofmap_crawl_setting_exclude_keywords
    used_sofmap_crawl_setting_exclude_products
    used_sofmap_crawl_setting_required_keywords
    used_sofmap_products
    yahoo_auction_crawl_setting_exclude_keywords
    yahoo_auction_crawl_setting_exclude_products
    yahoo_auction_crawl_setting_required_keywords
    yahoo_auction_daily_purchase_summaries
    yahoo_auction_products
    yahoo_fleamarket_daily_purchase_summaries
    yahoo_fleamarket_products
    iosys_crawl_settings
    janpara_crawl_settings
    mercari_crawl_settings
    pc_koubou_crawl_settings
    used_sofmap_crawl_settings
    yahoo_auction_crawl_settings
    product_category_maps
    category_hierarchies
    categories
    products
  ].freeze

  def up
    LEGACY_TABLES.each do |table_name|
      drop_table table_name
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
