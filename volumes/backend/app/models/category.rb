class Category < ApplicationRecord
  DEPTH_LIMIT = 2

  has_closure_tree

  ## associations ##
  has_many :product_category_maps, dependent: :destroy
  has_many :products, through: :product_category_maps

  ## validations ##
  validates :name, presence: true

  validate :validate_depth_limit

  ## methods ##
  private

  def validate_depth_limit
    return if root?
    return if parent.depth <= DEPTH_LIMIT

    errors.add(:base, "Depth limit exceeded. Maximum depth is #{DEPTH_LIMIT}.")
  end
end
