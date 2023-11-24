module Api
  module V1
    class YahooAuctionProductsController < ApplicationController
      def index
        products = YahooAuctionProductFinder.new(params: product_params).execute
        render json: { products: products.as_json }, status: 200
      end

      def show
        products = YahooAuctionProductFinder.new(params: { id: params[:id] }).execute
        render json: products.first.as_json, status: 200
      end

      def create; end

      def update; end

      def destroy; end

      private

      def yahoo_auction_product_params_attributes
        %i[id yahoo_auction_id name price published]
      end

      def product_params
        @product_params ||= params.require(:yahoo_auction_product).permit(yahoo_auction_product_params_attributes)
      end
    end
  end
end
