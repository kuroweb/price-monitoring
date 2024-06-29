class Category < ApplicationRecord
  DEPTH_LIMIT = 3

  has_closure_tree

  ## associations ##
  has_many :product_category_maps
  has_many :products, through: :product_category_maps

  ## validations ##
  validate :validate_depth_limit

  ## methods ##
  private

  def validate_depth_limit
    return if parent.nil? || parent.depth < DEPTH_LIMIT

    errors.add(:base, "Depth limit exceeded. Maximum depth is #{DEPTH_LIMIT}.")
  end
end
