module Api
  class ProductPriceDetailSerializer
    def initialize(params)
      @params = params.as_json.symbolize_keys
    end

    def as_json(_opts = {})
      product.as_json.merge("related_products" => related_products)
    end

    private

    attr_reader :params

    def related_products
      RetrieveRelatedProducts::Retriever.call(params: retrieve_params)
                                        .products.map(&:attributes)
    end

    def retrieve_params
      params[:product_id] = product.id
      params
    end

    def product
      @product ||= Product.find(params[:id])
    end
  end
end
