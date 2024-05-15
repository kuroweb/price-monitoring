module Api
  module V1
    module Products
      class JanparaCrawlSettingsController < ApplicationController
        def index
          render json: janpara_crawl_setting, status: 200
        end

        def janpara_crawl_setting
          @janpara_crawl_setting ||= JanparaCrawlSetting.find_by!(product_id: params[:product_id])
        end
      end
    end
  end
end
