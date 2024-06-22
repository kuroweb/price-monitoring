class Product < ApplicationRecord
  ## associations ##
  has_one :yahoo_auction_crawl_setting, dependent: :destroy
  has_one :mercari_crawl_setting, dependent: :destroy
  has_one :janpara_crawl_setting, dependent: :destroy
  has_one :iosys_crawl_setting, dependent: :destroy
  has_one :pc_koubou_crawl_setting, dependent: :destroy
  has_one :used_sofmap_crawl_setting, dependent: :destroy
  has_one :product_category_map, dependent: :destroy
  has_one :category, through: :product_category_map

  has_many :yahoo_auction_products, dependent: :destroy
  has_many :yahoo_auction_daily_purchase_summaries, dependent: :destroy
  has_many :yahoo_fleamarket_products, dependent: :destroy
  has_many :yahoo_fleamarket_daily_purchase_summaries, dependent: :destroy
  has_many :mercari_products, dependent: :destroy
  has_many :mercari_daily_purchase_summaries, dependent: :destroy
  has_many :janpara_products, dependent: :destroy
  has_many :iosys_products, dependent: :destroy
  has_many :pc_koubou_products, dependent: :destroy
  has_many :used_sofmap_products, dependent: :destroy

  ## validations ##
  validates :name, presence: true

  ## methods ##
end
