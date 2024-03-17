module Api
  module V1
    module Products
      class MercariCrawlSettingsController < ApplicationController
        def index
          mercari_crawl_setting = MercariCrawlSetting.find_by(product_id: params[:product_id])

          if mercari_crawl_setting
            render json: mercari_crawl_setting, status: 200
          else
            render json: { message: "Requested resource was not found." }, status: 404
          end
        end
      end
    end
  end
end
