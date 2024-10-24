class CategorySerializer < BaseSerializer
  delegate(*Category.column_names, to: :category)

  attr_reader :category

  def initialize(category)
    @category = category
  end

  private

  def attribute_names
    Category.column_names
  end
end
