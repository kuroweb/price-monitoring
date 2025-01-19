module Api
  module V1
    class ProductPricesController < Api::ApplicationController
      def index
        products = ProductFinder.new(params: { category_id: params[:category_id] }).execute
        render json: Api::ProductPriceListSerializer.new(products, list_params).as_json,
               status: :ok
      end

      def show
        product = Product.find(params[:id])
        render json: Api::ProductPriceDetailSerializer.new(product, detail_params).as_json,
               status: :ok
      end

      private

      def list_params
        params.permit(:platform_mask, :sort, :order, :price_display_limit)
      end

      def detail_params
        params.permit(:platform_mask, :sort, :order, :page, :per)
      end
    end
  end
end
