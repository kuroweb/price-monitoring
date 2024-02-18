module Api
  module V1
    module Products
      class YahooAuctionCrawlSettingExcludeConditionsController < ApplicationController
        def index
          yahoo_auction_crawl_setting = YahooAuctionCrawlSetting.find_by(product_id: params[:product_id])

          render json:
            { yahoo_auction_crawl_setting_exclude_conditions: yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_conditions }, status: 200
        end
      end
    end
  end
end
