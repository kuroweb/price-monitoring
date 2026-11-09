module Api
  module V1
    # 全商品モニタリング設定の商品日次相場を横断して返す
    class ProductAggregationResultsController < Api::ApplicationController
      def index
        render json: {
          product_aggregation_results: ProductAggregationResult.order(:product_watch_setting_id, :date).as_json
        }, status: :ok
      end
    end
  end
end
