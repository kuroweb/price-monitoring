module Api
  module V1
    module Products
      module IosysCrawlSettings
        class IosysCrawlSettingExcludeKeywordsController < ApplicationController
          def index
            render json: {
              iosys_crawl_setting_exclude_keywords:
                product.iosys_crawl_setting.iosys_crawl_setting_exclude_keywords
            }, status: 200
          end

          def create
            iosys_crawl_setting_exclude_keyword =
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_exclude_keywords
              .create!(iosys_crawl_setting_exclude_keyword_params)

            render json: iosys_crawl_setting_exclude_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            iosys_crawl_setting_exclude_keyword.update!(iosys_crawl_setting_exclude_keyword_params)
            render json: iosys_crawl_setting_exclude_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if iosys_crawl_setting_exclude_keyword.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def iosys_crawl_setting_exclude_keyword
            @iosys_crawl_setting_exclude_keyword ||=
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_exclude_keywords
              .find(params[:id])
          end

          def iosys_crawl_setting_exclude_keyword_attributes
            %i[keyword]
          end

          def iosys_crawl_setting_exclude_keyword_params
            params.permit(iosys_crawl_setting_exclude_keyword_attributes)
          end
        end
      end
    end
  end
end
