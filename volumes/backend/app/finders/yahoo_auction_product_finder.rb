class YahooAuctionProductFinder
  attr_reader :params

  def initialize(params: {})
    @params = params
  end

  def execute
    products = base_scope
    products = by_id(products)
    products = by_yahoo_auction_id(products)
    products = by_name(products)
    products = by_price(products)
    products = by_published(products)

    order(products)
  end

  private

  def base_scope
    YahooAuctionProduct.all
  end

  def by_id(products)
    return products unless params[:id]

    products.where(id: params[:id])
  end

  def by_yahoo_auction_id(products)
    return products unless params[:yahoo_auction_id]

    products.where(yahoo_auction_id: params[:yahoo_auction_id])
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
    return products unless params[:sort]

    products.order_by(params[:sort])
  end
end
