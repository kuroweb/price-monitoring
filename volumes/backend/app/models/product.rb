class Product < ApplicationRecord
  belongs_to :user

  has_one :yahoo_auction_crawl_setting

  has_many :yahoo_auction_products
end
