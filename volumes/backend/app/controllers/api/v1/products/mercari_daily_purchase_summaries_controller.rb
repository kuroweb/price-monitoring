module Api
  module V1
    module Products
      class MercariDailyPurchaseSummariesController < ApplicationController
        def index
          render json: { mercari_daily_purchase_summaries: product.mercari_daily_purchase_summaries },
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
