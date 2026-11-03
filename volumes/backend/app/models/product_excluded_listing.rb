class ProductExcludedListing < ApplicationRecord
  belongs_to :product
  validates :platform, :external_id, presence: true
end
