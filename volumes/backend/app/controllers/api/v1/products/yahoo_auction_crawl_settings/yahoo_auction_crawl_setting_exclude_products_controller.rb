module Api
  module V1
    module Products
      module YahooAuctionCrawlSettings
        class YahooAuctionCrawlSettingExcludeProductsController < ApplicationController
          def index
            render json: {
              yahoo_auction_crawl_setting_exclude_products:
                product.yahoo_auction_crawl_setting.yahoo_auction_crawl_setting_exclude_products
            }, status: 200
          end

          def create
            yahoo_auction_crawl_setting_exclude_product =
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_products
              .create!(yahoo_auction_crawl_setting_exclude_product_params)

            render json: yahoo_auction_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            yahoo_auction_crawl_setting_exclude_product.update!(yahoo_auction_crawl_setting_exclude_product_params)
            render json: yahoo_auction_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if yahoo_auction_crawl_setting_exclude_product.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def yahoo_auction_crawl_setting_exclude_product
            @yahoo_auction_crawl_setting_exclude_product ||=
              product
              .yahoo_auction_crawl_setting
              .yahoo_auction_crawl_setting_exclude_products
              .find(params[:id])
          end

          def yahoo_auction_crawl_setting_exclude_product_attributes
            %i[external_id]
          end

          def yahoo_auction_crawl_setting_exclude_product_params
            params.permit(yahoo_auction_crawl_setting_exclude_product_attributes)
          end
        end
      end
    end
  end
end
