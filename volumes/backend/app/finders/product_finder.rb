class ProductFinder
  attr_reader :params

  SORT_OPTIONS = %w[created_at updated_at].freeze
  ORDER_OPTIONS = %w[desc asc].freeze

  def initialize(params: {})
    @params = params
  end

  def execute
    products = base_scope
    products = by_id(products)
    products = by_name(products)
    products = by_category_id(products)

    order(products)
  end

  private

  def base_scope
    Product.all
  end

  def by_id(products)
    return products unless params[:id]

    products.where(id: params[:id])
  end

  def by_name(products)
    return products unless params[:name]

    products.where(name: params[:name])
  end

  def by_category_id(products)
    return products unless params[:category_id]

    products.joins(:product_category_map).where(product_category_maps: { category_id: params[:category_id] })
  end

  def order(products)
    return products if SORT_OPTIONS.exclude?(params[:sort]) ||
                       ORDER_OPTIONS.exclude?(params[:order])

    products.order("#{params[:sort]} #{params[:order]}")
  end
end
