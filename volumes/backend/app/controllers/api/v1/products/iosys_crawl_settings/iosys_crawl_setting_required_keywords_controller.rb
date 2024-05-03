module Api
  module V1
    module Products
      module IosysCrawlSettings
        class IosysCrawlSettingRequiredKeywordsController < ApplicationController
          def index
            render json: {
              iosys_crawl_setting_required_keywords:
                product.iosys_crawl_setting.iosys_crawl_setting_required_keywords
            }, status: 200
          end

          def create
            iosys_crawl_setting_required_keyword =
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_required_keywords
              .build(iosys_crawl_setting_required_keyword_params)

            if iosys_crawl_setting_required_keyword.save
              render json: iosys_crawl_setting_required_keyword.as_json, status: 200
            else
              render json: { message: iosys_crawl_setting_required_keyword.errors.full_messages }, status: 400
            end
          end

          def update
            iosys_crawl_setting_required_keyword =
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_required_keywords
              .find(params[:id])

            iosys_crawl_setting_required_keyword.assign_attributes(
              iosys_crawl_setting_required_keyword_params
            )

            if iosys_crawl_setting_required_keyword.save
              render json: iosys_crawl_setting_required_keyword.as_json, status: 200
            else
              render json: { message: iosys_crawl_setting_required_keyword.errors.full_messages }, status: 400
            end
          end

          def destroy
            iosys_crawl_setting_required_keyword =
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_required_keywords
              .find(params[:id])

            if iosys_crawl_setting_required_keyword.destroy
              head 200
            else
              render json: { message: result.message }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def iosys_crawl_setting_required_keyword_attributes
            %i[keyword]
          end

          def iosys_crawl_setting_required_keyword_params
            params.permit(iosys_crawl_setting_required_keyword_attributes)
          end
        end
      end
    end
  end
end
