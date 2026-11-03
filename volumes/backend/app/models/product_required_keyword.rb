class ProductRequiredKeyword < ApplicationRecord
  belongs_to :product
  validates :keyword, presence: true
end
