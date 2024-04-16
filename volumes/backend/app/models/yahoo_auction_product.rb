class YahooAuctionProduct < ApplicationRecord
  ## associations ##
  belongs_to :product

  ## validations ##
  validates :seller_id, presence: true
  validates :name, presence: true
  validates :thumbnail_url, presence: true

  ## scopes ##
  scope :published, -> { where(published: true) }
  scope :bought, -> { where.not(bought_date: nil) }

  ## methods ##
end
