module Api
  module V1
    module ProductAggregationSettings
      class ProductAggregationResultsController < Api::ApplicationController
        def index
          render json: {
            product_aggregation_results: product_aggregation_setting.product_aggregation_results.order(:date).as_json
          }, status: :ok
        end

        private

        def product_aggregation_setting
          @product_aggregation_setting ||= ProductAggregationSetting.find(params[:product_aggregation_setting_id])
        end
      end
    end
  end
end
