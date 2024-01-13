class Product < ApplicationRecord
  ## associations ##
  has_one :yahoo_auction_crawl_setting

  has_many :yahoo_auction_products

  ## validations ##

  ## methods ##
end
