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
              .create!(yahoo_auction_crawl_setting_required_keyword_params)

            render json: yahoo_auction_crawl_setting_required_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            yahoo_auction_crawl_setting_required_keyword.update!(yahoo_auction_crawl_setting_required_keyword_params)
            render json: yahoo_auction_crawl_setting_required_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if yahoo_auction_crawl_setting_required_keyword.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def yahoo_auction_crawl_setting_required_keyword
            @yahoo_auction_crawl_setting_required_keyword ||=
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_required_keywords
              .find(params[:id])
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
