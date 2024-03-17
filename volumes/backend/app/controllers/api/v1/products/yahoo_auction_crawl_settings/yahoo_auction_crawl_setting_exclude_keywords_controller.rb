module Api
  module V1
    module Products
      module YahooAuctionCrawlSettings
        class YahooAuctionCrawlSettingExcludeKeywordsController < ApplicationController
          def index
            render json: {
              yahoo_auction_crawl_setting_exclude_keywords:
                product.yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_exclude_keywords
            }, status: 200
          end

          def create
            yahoo_auction_crawl_setting_exclude_keyword =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_keywords
              .build(yahoo_auction_crawl_setting_exclude_keyword_params)

            if yahoo_auction_crawl_setting_exclude_keyword.save
              render json: yahoo_auction_crawl_setting_exclude_keyword.as_json, status: 200
            else
              render json: { message: yahoo_auction_crawl_setting_exclude_keyword.errors.full_messages }, status: 400
            end
          end

          def update
            yahoo_auction_crawl_setting_exclude_keyword =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_keywords
              .find(params[:id])

            yahoo_auction_crawl_setting_exclude_keyword.assign_attributes(
              yahoo_auction_crawl_setting_exclude_keyword_params
            )

            if yahoo_auction_crawl_setting_exclude_keyword.save
              render json: yahoo_auction_crawl_setting_exclude_keyword.as_json, status: 200
            else
              render json: { message: yahoo_auction_crawl_setting_exclude_keyword.errors.full_messages }, status: 400
            end
          end

          def destroy
            yahoo_auction_crawl_setting_exclude_keyword =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_keywords
              .find(params[:id])

            if yahoo_auction_crawl_setting_exclude_keyword.destroy
              head 200
            else
              render json: { message: result.message }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def yahoo_auction_crawl_setting_exclude_keyword_attributes
            %i[keyword]
          end

          def yahoo_auction_crawl_setting_exclude_keyword_params
            params.permit(yahoo_auction_crawl_setting_exclude_keyword_attributes)
          end
        end
      end
    end
  end
end
