class ProductCategoryMap < ApplicationRecord
  ## associations ##
  belongs_to :product
  belongs_to :category

  ## validations ##

  ## methods ##
end
