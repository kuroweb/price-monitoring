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
              .create!(yahoo_auction_crawl_setting_exclude_keyword_params)

            render json: yahoo_auction_crawl_setting_exclude_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid
            render json: { error: "Validation Error.", status: 400 }, status: 400
          end

          def update
            yahoo_auction_crawl_setting_exclude_keyword.update!(yahoo_auction_crawl_setting_exclude_keyword_params)
            render json: yahoo_auction_crawl_setting_exclude_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid
            render json: { error: "Validation Error.", status: 400 }, status: 400
          end

          def destroy
            yahoo_auction_crawl_setting_exclude_keyword.destroy!
            head 200
          rescue ActiveRecord::RecordInvalid
            render json: { error: "Validation Error.", status: 400 }, status: 400
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

          def yahoo_auction_crawl_setting_exclude_keyword
            @yahoo_auction_crawl_setting_exclude_keyword ||=
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_keywords
              .find(params[:id])
          end
        end
      end
    end
  end
end
