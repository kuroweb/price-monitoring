class CategoryClosure < ApplicationRecord
  ## associations ##
  belongs_to :parent, class_name: "Category"
  belongs_to :child, class_name: "Category"

  ## validations ##

  ## methods ##
end
