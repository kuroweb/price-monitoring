module Api
  module V1
    module Products
      class YahooAuctionDailyPurchaseSummariesController < ApplicationController
        def index
          render json: { yahoo_auction_daily_purchase_summaries: product.yahoo_auction_daily_purchase_summaries },
                 status: 200
        end

        private

        def product
          @product ||= Product.find(params[:product_id])
        end
      end
    end
  end
end
