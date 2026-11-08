module Api
  module V1
    class ProductWatchSettingsController < Api::ApplicationController
      rescue_from ArgumentError, with: :invalid_settings
      before_action :set_product_watch_setting, only: %i[update destroy results]

      def index
        render json: {
          product_watch_settings: ProductWatchSetting.order(id: :desc).as_json(except: :last_lowest_signature),
          discord_configured: ::ProductMonitoring::LowestPriceNotifier.configured?
        }, status: :ok
      end

      def create
        setting = ::ProductMonitoring::WatchSettingWriter.call(product_watch_setting: ProductWatchSetting.new,
                                                               params: upsert_params)
        render json: setting.as_json(except: :last_lowest_signature), status: :ok
      end

      def update
        ::ProductMonitoring::WatchSettingWriter.call(product_watch_setting: @product_watch_setting,
                                                     params: upsert_params)
        render json: @product_watch_setting.as_json(except: :last_lowest_signature), status: :ok
      end

      def destroy
        @product_watch_setting.destroy!
        render json: {}, status: :ok
      end

      def results
        results = ::ProductMonitoring::LowestListings.call(product_watch_setting: @product_watch_setting)
        render json: { product_crawl_results: results.as_json }, status: :ok
      end

      private

      def upsert_params
        params.permit(:name, :enabled, :discord_enabled, :min_price, :max_price, required_keywords: [],
                                                                                 exclude_keywords: [])
      end

      def set_product_watch_setting
        @product_watch_setting = ProductWatchSetting.find(params.expect(:id))
      end

      def invalid_settings(error)
        render json: build_error_json(400, error.message, []), status: :bad_request
      end
    end
  end
end
