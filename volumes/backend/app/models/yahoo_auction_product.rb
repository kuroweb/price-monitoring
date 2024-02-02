class YahooAuctionProduct < ApplicationRecord
  ## associations ##
  belongs_to :product

  ## validations ##

  ## scopes ##
  scope :published, -> { where(published: true) }

  ## methods ##
end
