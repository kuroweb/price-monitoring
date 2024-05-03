module Api
  module V1
    module Products
      class JanparaCrawlSettingsController < ApplicationController
        def index
          janpara_crawl_setting = JanparaCrawlSetting.find_by(product_id: params[:product_id])

          render json: janpara_crawl_setting, status: 200
        end
      end
    end
  end
end
