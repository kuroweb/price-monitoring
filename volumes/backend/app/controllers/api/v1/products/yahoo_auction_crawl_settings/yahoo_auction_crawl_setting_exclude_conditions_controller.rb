module Api
  module V1
    module Products
      module YahooAuctionCrawlSettings
        class YahooAuctionCrawlSettingExcludeConditionsController < ApplicationController
          def index
            render json: {
              yahoo_auction_crawl_setting_exclude_conditions:
                product.yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_exclude_conditions
            }, status: 200
          end

          def create
            yahoo_auction_crawl_setting_exclude_condition =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_conditions
              .build(create_yahoo_auction_crawl_setting_exclude_condition_params)

            if yahoo_auction_crawl_setting_exclude_condition.save
              render json: yahoo_auction_crawl_setting_exclude_condition.as_json, status: 200
            else
              render json: { message: yahoo_auction_crawl_setting_exclude_condition.errors.full_messages }, status: 400
            end
          end

          def destroy
            yahoo_auction_crawl_setting_exclude_condition =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_conditions
              .find(params[:id])

            if yahoo_auction_crawl_setting_exclude_condition.destroy
              head 200
            else
              render json: { message: result.message }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def yahoo_auction_crawl_setting_exclude_condition_attributes
            %i[keyword yahoo_auction_id seller_id]
          end

          def create_yahoo_auction_crawl_setting_exclude_condition_params
            params.permit(yahoo_auction_crawl_setting_exclude_condition_attributes)
          end
        end
      end
    end
  end
end
