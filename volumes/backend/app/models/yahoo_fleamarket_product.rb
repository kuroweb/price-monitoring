class YahooFleamarketProduct < ApplicationRecord
  ## associations ##
  belongs_to :product

  ## validations ##
  validates :external_id, :seller_id, :name, :thumbnail_url, presence: true

  ## scopes ##

  ## methods ##
end
