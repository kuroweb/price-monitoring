module Api
  module Products
    class RelatedProductListSerializer
      def initialize(products, params)
        @products = products
        @params = params.as_json.symbolize_keys
      end

      def as_json(_opts = {})
        @products.map do |product|
          product.as_json.merge("related_products" => related_products(product))
        end
      end

      private

      def related_products(product)
        RetrieveRelatedProducts::Retriever.call(params: { product_id: product.id, **@params })
                                          .products.map(&:attributes)
      end
    end
  end
end
