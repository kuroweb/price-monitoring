module Api
  module V1
    class ProductsController < Api::ApplicationController
      def index
        products = ProductFinder.new(params: find_product_params).execute
        render json: ProductsSerializer.new(products), status: :ok
      end

      private

      def find_product_params
        params.permit(product_attributes + external_attributes)
      end

      def product_attributes
        %i[id name]
      end

      def external_attributes
        %i[sort order]
      end
    end
  end
end
