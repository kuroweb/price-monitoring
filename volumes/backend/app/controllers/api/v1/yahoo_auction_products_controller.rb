module Api
  module V1
    class YahooAuctionProductsController < ApplicationController
      def index
        yahoo_auction_products = YahooAuctionProductFinder.new(params: yahoo_auction_product_params).execute
        render json: { yahoo_auction_products: yahoo_auction_products.as_json }, status: 200
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
        %i[id product_id yahoo_auction_id name price published]
      end

      def yahoo_auction_product_params
        @yahoo_auction_product_params ||= params.permit(yahoo_auction_product_params_attributes)
      end
    end
  end
end
