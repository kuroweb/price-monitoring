module Api
  module V1
    module Products
      class PcKoubouCrawlSettingsController < ApplicationController
        def index
          pc_koubou_crawl_setting = PcKoubouCrawlSetting.find_by(product_id: params[:product_id])

          if pc_koubou_crawl_setting
            render json: pc_koubou_crawl_setting, status: 200
          else
            render json: { message: "Requested resource was not found." }, status: 404
          end
        end
      end
    end
  end
end
