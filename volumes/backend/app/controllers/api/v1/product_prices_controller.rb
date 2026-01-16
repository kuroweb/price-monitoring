module Api
  module V1
    class ProductPricesController < Api::ApplicationController
      def index
        render json: Api::ProductPriceListSerializer.new(index_params).as_json,
               status: :ok
      end

      def show
        render json: Api::ProductPriceDetailSerializer.new(show_params).as_json,
               status: :ok
      end

      private

      def index_params
        params.permit(:platform_mask, :sort, :order, :price_display_limit, :category_id)
      end

      def show_params
        params.permit(:platform_mask, :sort, :order, :page, :per, :id)
      end
    end
  end
end
