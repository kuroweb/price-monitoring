class YahooAuctionProduct < ApplicationRecord
  belongs_to :product

  scope :published, -> { where(published: true) }
end
