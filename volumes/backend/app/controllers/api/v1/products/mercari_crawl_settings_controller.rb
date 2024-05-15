module Api
  module V1
    module Products
      class MercariCrawlSettingsController < ApplicationController
        def index
          render json: mercari_crawl_setting, status: 200
        end

        def mercari_crawl_setting
          @mercari_crawl_setting ||= MercariCrawlSetting.find_by!(product_id: params[:product_id])
        end
      end
    end
  end
end
