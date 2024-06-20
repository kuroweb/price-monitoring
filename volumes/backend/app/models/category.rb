class Category < ApplicationRecord
  ## associations ##
  has_many :product_category_maps
  has_many :products, through: :product_category_maps

  # 親カテゴリ
  has_many :ancestor_closures, class_name: "CategoryClosure", foreign_key: "descendant_id"
  has_many :ancestors, through: :ancestor_closures, source: :ancestor

  # 子カテゴリ
  has_many :descendant_closures, class_name: "CategoryClosure", foreign_key: "ancestor_id"
  has_many :descendants, through: :descendant_closures, source: :descendant

  ## validations ##
  validates :name, presence: true

  ## methods ##
  # すべての親カテゴリ
  def parent_categories
    ancestors.where.not(id:)
  end

  # 直近の親カテゴリ
  def direct_parent_categories
    ancestors.where("category_closures.depth = 1")
  end

  # すべての子カテゴリ
  def child_categories
    descendants.where.not(id:)
  end

  # 直近の子カテゴリ
  def direct_child_categories
    descendants.where("category_closures.depth = 1")
  end

  # 親カテゴリに子カテゴリを追加
  def add_child_category(child)
    CategoryClosure.transaction do
      # 自分自身との関係を追加
      CategoryClosure.find_or_create_by!(ancestor: child, descendant: child, depth: 0)

      # 直近の親子関係を追加
      CategoryClosure.find_or_create_by!(ancestor: self, descendant: child, depth: 1)

      # 先祖の全ての関係を追加
      ancestor_closures.each do |closure|
        CategoryClosure.find_or_create_by!(ancestor: closure.ancestor, descendant: child, depth: closure.depth + 1)
      end
    end
  end
end
