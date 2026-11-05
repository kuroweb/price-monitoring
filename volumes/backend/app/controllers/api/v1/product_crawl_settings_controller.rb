module Api
  module V1
    class ProductCrawlSettingsController < Api::ApplicationController
      rescue_from ArgumentError, with: :invalid_settings

      before_action :set_product_crawl_setting, only: %i[show update destroy sync]

      def index
        product_crawl_settings = ProductCrawlSetting.order(id: :desc)
        render json: { product_crawl_settings: product_crawl_settings.as_json }, status: :ok
      end

      def show
        render json: @product_crawl_setting.as_json, status: :ok
      end

      def create
        product_crawl_setting = ::ProductCrawlSettings::Writer.call(product_crawl_setting: ProductCrawlSetting.new,
                                                                    params: upsert_params)
        render json: product_crawl_setting.as_json, status: :ok
      end

      def update
        ::ProductCrawlSettings::Writer.call(product_crawl_setting: @product_crawl_setting, params: upsert_params)
        render json: @product_crawl_setting.as_json, status: :ok
      end

      def destroy
        if @product_crawl_setting.destroy
          render json: {}, status: :ok
        else
          render json: build_error_json(400, "Bad Request.", []), status: :bad_request
        end
      end

      # 保存していない条件で取得し、結果を保存せずに返す
      def preview
        render json: Crawl::Search::Preview.call(params: upsert_params), status: :ok
      end

      # 保存済みの条件で取得し、採用した出品を商品計測結果に保存する
      def sync
        render json: ::ProductCrawlSettings::SyncResults.call(product_crawl_setting: @product_crawl_setting),
               status: :ok
      end

      private

      def upsert_params
        params.permit(:name, :enabled, :min_price, :max_price,
                      search_urls: [], required_keywords: [], exclude_keywords: [], exclude_external_ids: [])
      end

      def set_product_crawl_setting
        @product_crawl_setting = ProductCrawlSetting.find(params[:id])
      end

      def invalid_settings(error)
        render json: build_error_json(400, error.message, []), status: :bad_request
      end
    end
  end
end
