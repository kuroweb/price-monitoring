module Api
  module V1
    module Products
      module YahooAuctionCrawlSettings
        class YahooAuctionCrawlSettingExcludeKeywordsController < Api::ApplicationController
          def create
            exclude_keyword = product.yahoo_auction_crawl_setting
                                     .yahoo_auction_crawl_setting_exclude_keywords
                                     .create!(exclude_keyword_params)
            inspect
            render json: exclude_keyword.as_json, status: :ok
          end

          def update
            exclude_keyword.update!(exclude_keyword_params)
            inspect
            render json: exclude_keyword.as_json, status: :ok
          end

          def destroy
            if exclude_keyword.destroy
              render json: {}, status: :ok
            else
              render json: { error: "Bad Request.", status: 400 }, status: :bad_request
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def exclude_keyword
            @exclude_keyword ||= product.yahoo_auction_crawl_setting
                                        .yahoo_auction_crawl_setting_exclude_keywords
                                        .find(params[:id])
          end

          def exclude_keyword_params
            params.permit(exclude_keyword_attributes)
          end

          def exclude_keyword_attributes
            %i[keyword]
          end

          def inspect
            ::Products::Inspect::DeleteYahooAuctionProducts.call(product:)
            ::Products::Inspect::DeleteYahooFleamarketProducts.call(product:)
          end
        end
      end
    end
  end
end
