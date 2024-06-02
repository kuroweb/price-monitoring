module Api
  module V1
    module Products
      class UsedSofmapCrawlSettingsController < ApplicationController
        def index
          render json: used_sofmap_crawl_setting, status: 200
        end

        def used_sofmap_crawl_setting
          @used_sofmap_crawl_setting ||= UsedSofmapCrawlSetting.find_by!(product_id: params[:product_id])
        end
      end
    end
  end
end
