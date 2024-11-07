module Api
  module Products
    class ProductsSerializer < BaseSerializer
      def initialize(products)
        @products = products
      end

      private

      def json
        {
          products: products_json
        }
      end

      def products_json
        @products.map do |product|
          ProductSerializer.new(product).render_json
        end
      end
    end
  end
end
