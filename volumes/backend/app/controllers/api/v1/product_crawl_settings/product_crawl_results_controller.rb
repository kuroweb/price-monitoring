module Api
  module V1
    module ProductCrawlSettings
      class ProductCrawlResultsController < Api::ApplicationController
        def index
          render json: {
            product_crawl_results: product_crawl_setting.product_crawl_results.order(id: :desc).as_json
          }, status: :ok
        end

        private

        def product_crawl_setting
          @product_crawl_setting ||= ProductCrawlSetting.find(params[:product_crawl_setting_id])
        end
      end
    end
  end
end
