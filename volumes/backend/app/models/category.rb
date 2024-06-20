class Category < ApplicationRecord
  ## associations ##
  has_many :product_category_maps
  has_many :products, through: :product_category_maps

  # 親カテゴリ
  has_many :ancestor_closures, class_name: "CategoryClosure", foreign_key: "descendant_id", dependent: :destroy
  has_many :ancestors, through: :ancestor_closures, source: :ancestor

  # 子カテゴリ
  has_many :descendant_closures, class_name: "CategoryClosure", foreign_key: "ancestor_id", dependent: :destroy
  has_many :descendants, through: :descendant_closures, source: :descendant

  ## validations ##
  validates :name, presence: true

  ## hooks ##
  before_destroy :rebuild_tree_structure

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

  # 親カテゴリを追加
  def add_parent_category(parent_category)
    CategoryClosure.transaction do
      # 自分自身との関係を追加（存在しない場合）
      CategoryClosure.find_or_create_by!(ancestor: parent_category, descendant: parent_category, depth: 0)

      # 直近の親子関係を追加（存在しない場合）
      CategoryClosure.find_or_create_by!(ancestor: parent_category, descendant: self, depth: 1)

      # 既存の子孫との関係を更新
      descendant_closures.each do |closure|
        new_depth = closure.depth + 1
        CategoryClosure.find_or_create_by!(ancestor: parent_category, descendant: closure.descendant, depth: new_depth)
      end
    end
  end

  # 親カテゴリに子カテゴリを追加
  def add_child_category(child_category)
    CategoryClosure.transaction do
      # 自分自身との関係を追加
      CategoryClosure.find_or_create_by!(ancestor: child_category, descendant: child_category, depth: 0)

      # 直近の親子関係を追加
      CategoryClosure.find_or_create_by!(ancestor: self, descendant: child_category, depth: 1)

      # 先祖の全ての関係を追加
      ancestor_closures.each do |closure|
        CategoryClosure.find_or_create_by!(
          ancestor: closure.ancestor, descendant: child_category,
          depth: closure.depth + 1
        )
      end
    end
  end

  private

  def rebuild_tree_structure # rubocop:disable Metrics/AbcSize
    CategoryClosure.transaction do
      # 直近の親カテゴリーを取得
      parents = direct_parent_categories.to_a

      # 直近の子カテゴリーを取得
      children = direct_child_categories.to_a

      # 親カテゴリーと子カテゴリーの新しい関係を作成
      parents.each do |parent|
        children.each do |child|
          new_depth = parent.ancestor_closures.find_by(
            descendant: self
          ).depth + child.ancestor_closures.find_by(descendant: self).depth
          CategoryClosure.find_or_create_by!(ancestor: parent, descendant: child, depth: new_depth)
        end
      end

      # 既存の親子関係を削除
      CategoryClosure.where(descendant: self).or(CategoryClosure.where(ancestor: self)).destroy_all
    end
  end
end
