class PriceVersion < ApplicationRecord
  belongs_to :product
  belongs_to :crawl_history
end
