module Api
  module V1
    module Products
      module JanparaCrawlSettings
        class JanparaCrawlSettingExcludeKeywordsController < ApplicationController
          def index
            render json: {
              janpara_crawl_setting_exclude_keywords:
                product.janpara_crawl_setting.janpara_crawl_setting_exclude_keywords
            }, status: 200
          end

          def create
            janpara_crawl_setting_exclude_keyword =
              product
              .janpara_crawl_setting
              .janpara_crawl_setting_exclude_keywords
              .build(janpara_crawl_setting_exclude_keyword_params)

            if janpara_crawl_setting_exclude_keyword.save
              render json: janpara_crawl_setting_exclude_keyword.as_json, status: 200
            else
              render json: { message: janpara_crawl_setting_exclude_keyword.errors.full_messages }, status: 400
            end
          end

          def update
            janpara_crawl_setting_exclude_keyword =
              product
              .janpara_crawl_setting
              .janpara_crawl_setting_exclude_keywords
              .find(params[:id])

            janpara_crawl_setting_exclude_keyword.assign_attributes(
              janpara_crawl_setting_exclude_keyword_params
            )

            if janpara_crawl_setting_exclude_keyword.save
              render json: janpara_crawl_setting_exclude_keyword.as_json, status: 200
            else
              render json: { message: janpara_crawl_setting_exclude_keyword.errors.full_messages }, status: 400
            end
          end

          def destroy
            janpara_crawl_setting_exclude_keyword =
              product
              .janpara_crawl_setting
              .janpara_crawl_setting_exclude_keywords
              .find(params[:id])

            if janpara_crawl_setting_exclude_keyword.destroy
              head 200
            else
              render json: { message: result.message }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def janpara_crawl_setting_exclude_keyword_attributes
            %i[keyword]
          end

          def janpara_crawl_setting_exclude_keyword_params
            params.permit(janpara_crawl_setting_exclude_keyword_attributes)
          end
        end
      end
    end
  end
end
