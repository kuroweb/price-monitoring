module Api
  module V1
    module Products
      class CalculateDailyYahooAuctionProductsController < ApplicationController
        def index
          product = Product.find(params[:product_id])
          render json: { calculate_daily_yahoo_auction_products: product.calculate_daily_yahoo_auction_products },
                 status: 200
        end
      end
    end
  end
end
