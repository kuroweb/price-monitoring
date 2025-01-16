module Api
  class ProductPriceDetailSerializer
    JSON_OPTIONS = {
      include: %i[
        yahoo_auction_daily_purchase_summaries
        yahoo_fleamarket_daily_purchase_summaries
        mercari_daily_purchase_summaries
      ]
    }.freeze

    def initialize(product, params)
      @product = product
      @params = params.as_json.symbolize_keys
    end

    def as_json(_opts = {})
      @product.as_json(JSON_OPTIONS).merge("related_products" => related_products)
    end

    private

    def related_products
      RetrieveRelatedProducts::Retriever.call(params: { product_id: @product.id, **@params })
                                        .products.map(&:attributes)
    end
  end
end
