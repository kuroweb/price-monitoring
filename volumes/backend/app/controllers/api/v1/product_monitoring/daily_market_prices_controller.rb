module Api
  module V1
    module ProductMonitoring
      class DailyMarketPricesController < Api::ApplicationController
        def index
          render json: {
            daily_market_prices: ::ProductMonitoring::DailyMarketPrice.order(:monitor_id, :date).as_json
          }, status: :ok
        end
      end
    end
  end
end
