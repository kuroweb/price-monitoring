class ProductAggregationResult < ApplicationRecord
  ## associations ##
  belongs_to :product_watch_setting

  ## validations ##
  validates :date, presence: true

  ## scopes ##

  ## methods ##
end
