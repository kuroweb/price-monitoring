module Api
  module V1
    module Products
      class YahooAuctionCrawlSettingsController < ApplicationController
        def index
          yahoo_auction_crawl_setting = YahooAuctionCrawlSetting.find_by(product_id: params[:product_id])

          if yahoo_auction_crawl_setting
            render json: yahoo_auction_crawl_setting, status: 200
          else
            render json: { message: "Requested resource was not found." }, status: 404
          end
        end
      end
    end
  end
end
