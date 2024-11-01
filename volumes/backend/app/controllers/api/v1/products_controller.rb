module Api
  module V1
    class ProductsController < Api::ApplicationController
      def index
        products = ProductFinder.new(params: find_product_params).execute
        render json: ProductsSerializer.new(products), status: :ok
      end

      def destroy
        product = Product.find(params[:id])

        if product.destroy
          render json: {}, status: :ok
        else
          render json: build_error_json(500, "Bad Request.", []), status: :bad_request
        end
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

      def build_error_json(code, message, details)
        {
          error: {
            code:,
            message:,
            details:
          }
        }
      end
    end
  end
end
