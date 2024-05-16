class MercariProductFinder
  attr_reader :params

  SORT_OPTIONS = %w[bought_date created_at updated_at].freeze
  ORDER_OPTIONS = %w[desc asc].freeze

  def initialize(params: {})
    @params = params
  end

  def execute
    products = base_scope
    products = by_id(products)
    products = by_product_id(products)
    products = by_external_id(products)
    products = by_name(products)
    products = by_price(products)
    products = by_published(products)

    order(products)
  end

  private

  def base_scope
    MercariProduct.all
  end

  def by_id(products)
    return products unless params[:id]

    products.where(id: params[:id])
  end

  def by_product_id(products)
    return products unless params[:product_id]

    products.where(product_id: params[:product_id])
  end

  def by_external_id(products)
    return products unless params[:external_id]

    products.where(external_id: params[:external_id])
  end

  def by_name(products)
    return products unless params[:name]

    products.where(name: params[:name])
  end

  def by_price(products)
    return products unless params[:price]

    products.where(price: params[:price])
  end

  def by_published(products)
    return products unless params[:published]

    products.where(published: params[:published])
  end

  def order(products)
    return products if SORT_OPTIONS.exclude?(params[:sort]) ||
                       ORDER_OPTIONS.exclude?(params[:order])

    products.order("#{params[:sort]} #{params[:order]}")
  end
end
