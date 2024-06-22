class Category < ApplicationRecord
  has_closure_tree

  ## associations ##
  has_many :product_category_maps
  has_many :products, through: :product_category_maps

  ## validations ##

  ## methods ##
end
