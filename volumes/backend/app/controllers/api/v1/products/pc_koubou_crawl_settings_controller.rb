module Api
  module V1
    module Products
      class PcKoubouCrawlSettingsController < ApplicationController
        def index
          render json: pc_koubou_crawl_setting, status: 200
        end

        def pc_koubou_crawl_setting
          @pc_koubou_crawl_setting ||= PcKoubouCrawlSetting.find_by!(product_id: params[:product_id])
        end
      end
    end
  end
end
