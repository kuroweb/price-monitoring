module Api
  module V1
    module Products
      module YahooAuctionCrawlSettings
        class YahooAuctionCrawlSettingExcludeConditionsController < ApplicationController
          def index
            yahoo_auction_crawl_setting_exclude_conditions = YahooAuctionCrawlSettingExcludeCondition.where(
              yahoo_auction_crawl_setting_id: params[:yahoo_auction_crawl_setting_id]
            )

            render json: { yahoo_auction_crawl_setting_exclude_conditions: }, status: 200
          end
        end
      end
    end
  end
end
