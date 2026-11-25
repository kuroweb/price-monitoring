class Product < ApplicationRecord
  ## associations ##
  has_one :product_category_map, dependent: :destroy
  has_one :category, through: :product_category_map

  ## validations ##
  validates :name, presence: true

  ## methods ##
end
