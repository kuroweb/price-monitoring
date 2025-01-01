module Api
  module V1
    class RelatedProductsController < Api::ApplicationController
      def index
        render json: Api::Products::RelatedProductListSerializer.new(products, search_params).as_json,
               status: :ok
      end

      private

      def products
        @products ||= Product.all
      end

      def search_params
        params.permit(:platform_mask, :page, :per, :sort, :order)
      end
    end
  end
end
