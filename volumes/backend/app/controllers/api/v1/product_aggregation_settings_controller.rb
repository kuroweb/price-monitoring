module Api
  module V1
    class ProductAggregationSettingsController < Api::ApplicationController
      CALCULATE_DAYS = 30

      rescue_from ArgumentError, with: :invalid_settings

      before_action :set_product_aggregation_setting, only: %i[show update destroy calculate purchases]

      def index
        product_aggregation_settings = ProductAggregationSetting.order(id: :desc)
        render json: { product_aggregation_settings: product_aggregation_settings.as_json }, status: :ok
      end

      def show
        render json: @product_aggregation_setting.as_json, status: :ok
      end

      def create
        product_aggregation_setting = ::ProductMonitoring::AggregationSettingWriter.call(
          product_aggregation_setting: ProductAggregationSetting.new, params: upsert_params
        )
        render json: product_aggregation_setting.as_json, status: :ok
      end

      def update
        ::ProductMonitoring::AggregationSettingWriter.call(
          product_aggregation_setting: @product_aggregation_setting, params: upsert_params
        )
        render json: @product_aggregation_setting.as_json, status: :ok
      end

      def destroy
        if @product_aggregation_setting.destroy
          render json: {}, status: :ok
        else
          render json: build_error_json(400, "Bad Request.", []), status: :bad_request
        end
      end

      # 直近30日分の商品日次相場を計算し直す
      def calculate
        end_date = Time.zone.today
        ::ProductMonitoring::CalculateAggregationResults.call(
          product_aggregation_setting: @product_aggregation_setting,
          start_date: end_date - (CALCULATE_DAYS - 1),
          end_date:
        )
        render json: {}, status: :ok
      end

      # start_date〜end_date の集計対象になる購入を、売れた日の新しい順に返す
      def purchases
        product_crawl_results = ::ProductMonitoring::AggregationPurchases.call(
          product_aggregation_setting: @product_aggregation_setting,
          start_date: Date.parse(params.require(:start_date)),
          end_date: Date.parse(params.require(:end_date))
        )
        product_crawl_results = product_crawl_results.sort_by(&:bought_date).reverse
        render json: { product_crawl_results: product_crawl_results.as_json }, status: :ok
      end

      private

      def upsert_params
        params.permit(:name, :min_price, :max_price, required_keywords: [], exclude_keywords: [])
      end

      def set_product_aggregation_setting
        @product_aggregation_setting = ProductAggregationSetting.find(params[:id])
      end

      def invalid_settings(error)
        render json: build_error_json(400, error.message, []), status: :bad_request
      end
    end
  end
end
