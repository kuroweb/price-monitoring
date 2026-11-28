module Api
  module V1
    module ProductMonitoring
      class CrawlSettingsController < Api::ApplicationController
        rescue_from ArgumentError, with: :invalid_settings

        before_action :set_crawl_setting, only: %i[show update destroy sync]

        def index
          crawl_settings = ::ProductMonitoring::CrawlSetting.order(id: :desc)
          render json: { crawl_settings: crawl_settings.as_json }, status: :ok
        end

        def show
          render json: @crawl_setting.as_json, status: :ok
        end

        def create
          crawl_setting = ::ProductMonitoring::CrawlSetting::Writer.call(
            crawl_setting: ::ProductMonitoring::CrawlSetting.new, params: upsert_params
          )
          render json: crawl_setting.as_json, status: :ok
        end

        def update
          ::ProductMonitoring::CrawlSetting::Writer.call(
            crawl_setting: @crawl_setting, params: upsert_params
          )
          render json: @crawl_setting.as_json, status: :ok
        end

        def destroy
          if @crawl_setting.destroy
            render json: {}, status: :ok
          else
            render json: build_error_json(400, "Bad Request.", []), status: :bad_request
          end
        end

        def sync
          urls_by_platform = ::ProductMonitoring::Crawling::UrlRouter.call(crawl_setting: @crawl_setting)
          urls_by_platform.each_key { |platform| platform::ListPage::SyncJob.perform_async(@crawl_setting.id, true) }
          render json: {}, status: :accepted
        end

        private

        def upsert_params
          params.permit(:name, :enabled, :search_keyword, :min_price, :max_price,
                        platforms: [], search_urls: [], required_keywords: [], negative_keywords: [])
        end

        def set_crawl_setting
          @crawl_setting = ::ProductMonitoring::CrawlSetting.find(params[:id])
        end

        def invalid_settings(error)
          render json: build_error_json(400, error.message, []), status: :bad_request
        end
      end
    end
  end
end
