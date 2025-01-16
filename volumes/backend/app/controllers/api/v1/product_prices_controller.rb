module Api
  module V1
    class ProductPricesController < Api::ApplicationController
      def index
        render json: Api::ProductPriceListSerializer.new(products, search_params).as_json,
               status: :ok
      end

      def show
        render json: Api::ProductPriceDetailSerializer.new(product, search_params).as_json,
               status: :ok
      end

      private

      def products
        @products ||= Product.all
      end

      def product
        Product.find(params[:id])
      end

      def search_params
        params.permit(:platform_mask, :page, :per, :sort, :order)
      end
    end
  end
end
