class ProductExcludeKeyword < ApplicationRecord
  belongs_to :product
  validates :keyword, presence: true
end
