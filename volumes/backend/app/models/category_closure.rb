class CategoryClosure < ApplicationRecord
  ## associations ##
  belongs_to :ancestor, class_name: "Category"
  belongs_to :descendant, class_name: "Category"

  ## validations ##

  ## methods ##
end
