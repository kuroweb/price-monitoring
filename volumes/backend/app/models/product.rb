class Product < ApplicationRecord
  has_one :yahoo_auction_crawl_setting

  has_many :yahoo_auction_products

  def crawlable_name
    name.gsub(" ", "+")
  end
end
