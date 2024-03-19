class Product < ApplicationRecord
  ## associations ##
  has_one :yahoo_auction_crawl_setting, dependent: :destroy
  has_one :mercari_crawl_setting, dependent: :destroy

  has_many :yahoo_auction_products, dependent: :destroy
  has_many :mercari_products, dependent: :destroy

  ## validations ##

  ## methods ##
end
