module Api
  module V1
    module ProductMonitoring
      # 全モニタリング設定の日次相場を横断して返す
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
