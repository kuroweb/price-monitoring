class Product < ApplicationRecord
  ## associations ##
  has_one :yahoo_auction_crawl_setting, dependent: :destroy
  has_one :product_category_map, dependent: :destroy
  has_one :category, through: :product_category_map

  has_many :yahoo_auction_products, dependent: :destroy
  has_many :yahoo_auction_daily_purchase_summaries, dependent: :destroy
  has_many :yahoo_fleamarket_products, dependent: :destroy
  has_many :yahoo_fleamarket_daily_purchase_summaries, dependent: :destroy

  ## validations ##
  validates :name, presence: true

  ## methods ##
end
