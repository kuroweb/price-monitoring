class CategoryFinder
  attr_reader :params

  def initialize(params: {})
    @params = params
  end

  def execute
    categories = base_scope
    categories = by_root_only(categories)
    categories = by_name(categories)

    categories
  end

  private

  def base_scope
    Category.all
  end

  def by_root_only(categories)
    return categories unless params[:root_only]

    categories.roots
  end

  def by_name(categories)
    return categories unless params[:name]

    categories.where("name LIKE ?", "%#{params[:name]}%")
  end
end
