module Api
  module V1
    module Products
      class YahooAuctionCrawlSettingsController < ApplicationController
        def index
          render json: yahoo_auction_crawl_setting, status: 200
        end

        def yahoo_auction_crawl_setting
          @yahoo_auction_crawl_setting ||= YahooAuctionCrawlSetting.find_by!(product_id: params[:product_id])
        end
      end
    end
  end
end
