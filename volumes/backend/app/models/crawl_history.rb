class CrawlHistory < ApplicationRecord
  belongs_to :product

  has_one :price_version
end
