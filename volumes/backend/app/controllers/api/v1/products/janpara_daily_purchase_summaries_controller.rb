module Api
  module V1
    module Products
      class JanparaDailyPurchaseSummariesController < ApplicationController
        def index
          render json: { janpara_daily_purchase_summaries: product.janpara_daily_purchase_summaries },
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
