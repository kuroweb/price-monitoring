module Api
  module V1
    module Products
      class IosysCrawlSettingsController < ApplicationController
        def index
          render json: iosys_crawl_setting, status: 200
        end

        def iosys_crawl_setting
          @iosys_crawl_setting ||= IosysCrawlSetting.find_by!(product_id: params[:product_id])
        end
      end
    end
  end
end
