module Api
  module V1
    module Products
      class IosysCrawlSettingsController < ApplicationController
        def index
          iosys_crawl_setting = IosysCrawlSetting.find_by(product_id: params[:product_id])

          if iosys_crawl_setting
            render json: iosys_crawl_setting, status: 200
          else
            render json: { message: "Requested resource was not found." }, status: 404
          end
        end
      end
    end
  end
end
