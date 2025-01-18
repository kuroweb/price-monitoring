module Api
  class ProductPriceListSerializer
    def initialize(products, params)
      @products = products
      @params = params.as_json.symbolize_keys
    end

    def as_json(_opts = {})
      @products.map do |product|
        product.as_json.merge("related_products" => related_products(product.id))
      end
    end

    private

    def related_products(product_id)
      RetrieveRelatedProducts::Retriever.call(params: retrieve_params(product_id))
                                        .products.map(&:attributes)
    end

    def retrieve_params(product_id)
      {
        product_id:,
        platform_mask: @params[:platform_mask],
        sort: @params[:sort],
        order: @params[:order],
        page: 1,
        per: @params[:price_display_limit]
      }
    end
  end
end
