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
        # TODO: シリアライザの導入
        result = Products::CreateService.call(params: product_params)

        if result.success?
          render json: result.payload[:product].as_json, status: 200
        else
          render json: { message: result.message }, status: 400
        end
      end

      def update; end

      def destroy; end

      private

      def product_attributes
        %i[id name]
      end

      def yahoo_auction_crawl_setting_attributes
        %i[keyword category_id min_price max_price enabled]
      end

      def product_params
        @product_params ||= params.permit(
          product_attributes,
          yahoo_auction_crawl_setting: yahoo_auction_crawl_setting_attributes
        )
      end
    end
  end
end
