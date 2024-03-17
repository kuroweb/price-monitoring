module Api
  module V1
    module Products
      class YahooAuctionProductsController < ApplicationController
        def index
          yahoo_auction_products = YahooAuctionProductFinder.new(params: yahoo_auction_product_params).execute
          render json: { yahoo_auction_products: }, status: 200
        end

        def show
          yahoo_auction_product = YahooAuctionProduct.find_by(id: params[:id])

          if yahoo_auction_product
            render json: yahoo_auction_product, status: 200
          else
            render json: { message: "Requested resource was not found." }, status: 404
          end
        end

        def create; end

        def update; end

        def destroy; end

        private

        def yahoo_auction_product_params_attributes
          %i[id product_id yahoo_auction_id name price published]
        end

        def external_params_attributes
          %i[sort order]
        end

        def yahoo_auction_product_params
          @yahoo_auction_product_params ||=
            params.permit(yahoo_auction_product_params_attributes + external_params_attributes)
        end
      end
    end
  end
end
