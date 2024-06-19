class Category < ApplicationRecord
  ## associations ##
  has_many :product_category_maps
  has_many :products, through: :product_category_maps

  # 親カテゴリ
  has_one :parent_category_closure, class_name: "CategoryClosure", foreign_key: "child_id"
  has_one :parent_category, through: :parent_category_closure, source: :parent

  # 子カテゴリ
  has_many :child_category_closures, class_name: "CategoryClosure", foreign_key: "parent_id"
  has_many :child_categories, through: :child_category_closures, source: :child

  ## validations ##
  validates :name, presence: true

  ## methods ##
end
