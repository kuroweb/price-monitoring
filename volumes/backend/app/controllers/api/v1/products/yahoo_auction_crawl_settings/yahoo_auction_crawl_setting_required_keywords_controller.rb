module Api
  module V1
    module Products
      module YahooAuctionCrawlSettings
        class YahooAuctionCrawlSettingRequiredKeywordsController < ApplicationController
          def index
            render json: {
              yahoo_auction_crawl_setting_required_keywords:
                product.yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_required_keywords
            }, status: 200
          end

          def create
            yahoo_auction_crawl_setting_required_keyword =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_required_keywords
              .build(yahoo_auction_crawl_setting_required_keyword_params)

            if yahoo_auction_crawl_setting_required_keyword.save
              render json: yahoo_auction_crawl_setting_required_keyword.as_json, status: 200
            else
              render json: { message: yahoo_auction_crawl_setting_required_keyword.errors.full_messages }, status: 400
            end
          end

          def update
            yahoo_auction_crawl_setting_required_keyword =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_required_keywords
              .find(params[:id])

            yahoo_auction_crawl_setting_required_keyword.assign_attributes(
              yahoo_auction_crawl_setting_required_keyword_params
            )

            if yahoo_auction_crawl_setting_required_keyword.save
              render json: yahoo_auction_crawl_setting_required_keyword.as_json, status: 200
            else
              render json: { message: yahoo_auction_crawl_setting_required_keyword.errors.full_messages }, status: 400
            end
          end

          def destroy
            yahoo_auction_crawl_setting_required_keyword =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_required_keywords
              .find(params[:id])

            if yahoo_auction_crawl_setting_required_keyword.destroy
              head 200
            else
              render json: { message: result.message }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def yahoo_auction_crawl_setting_required_keyword_attributes
            %i[keyword]
          end

          def yahoo_auction_crawl_setting_required_keyword_params
            params.permit(yahoo_auction_crawl_setting_required_keyword_attributes)
          end
        end
      end
    end
  end
end
