module Api
  module V1
    class ProductsController < ApplicationController
      def index
        products = ProductFinder.new(params: product_params).execute
        render json: { products: products.as_json }, status: 200
      end

      def show
        products = ProductFinder.new(params: { id: params[:id] }).execute
        render json: products.first.as_json, status: 200
      end

      def create; end

      def update; end

      def destroy; end

      private

      def product_params_attributes
        %i[id user_id name price]
      end

      def product_params
        @product_params ||= params.require(:product).permit(product_params_attributes)
      end
    end
  end
end
