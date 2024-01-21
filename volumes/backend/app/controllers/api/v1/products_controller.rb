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

      def create
        result = Products::Create.call(params: product_params)

        if result.success?
          render json: { product: result.payload[:product].as_json }, status: 200
        else
          render json: { message: result.message }, status: result.status
        end
      end

      def update; end

      def destroy; end

      private

      def product_params_attributes
        %i[id name]
      end

      def product_params
        @product_params ||= params.permit(product_params_attributes)
      end
    end
  end
end
