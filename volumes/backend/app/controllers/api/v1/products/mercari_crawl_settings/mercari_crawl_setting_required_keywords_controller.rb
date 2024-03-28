module Api
  module V1
    module Products
      module MercariCrawlSettings
        class MercariCrawlSettingRequiredKeywordsController < ApplicationController
          def index
            render json: {
              mercari_crawl_setting_required_keywords:
                product.mercari_crawl_setting.mercari_crawl_setting_required_keywords
            }, status: 200
          end

          def create
            mercari_crawl_setting_required_keyword =
              product
              .mercari_crawl_setting
              .mercari_crawl_setting_required_keywords
              .build(mercari_crawl_setting_required_keyword_params)

            if mercari_crawl_setting_required_keyword.save
              render json: mercari_crawl_setting_required_keyword.as_json, status: 200
            else
              render json: { message: mercari_crawl_setting_required_keyword.errors.full_messages }, status: 400
            end
          end

          def update
            mercari_crawl_setting_required_keyword =
              product
              .mercari_crawl_setting
              .mercari_crawl_setting_required_keywords
              .find(params[:id])

            mercari_crawl_setting_required_keyword.assign_attributes(
              mercari_crawl_setting_required_keyword_params
            )

            if mercari_crawl_setting_required_keyword.save
              render json: mercari_crawl_setting_required_keyword.as_json, status: 200
            else
              render json: { message: mercari_crawl_setting_required_keyword.errors.full_messages }, status: 400
            end
          end

          def destroy
            mercari_crawl_setting_required_keyword =
              product
              .mercari_crawl_setting
              .mercari_crawl_setting_required_keywords
              .find(params[:id])

            if mercari_crawl_setting_required_keyword.destroy
              head 200
            else
              render json: { message: result.message }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def mercari_crawl_setting_required_keyword_attributes
            %i[keyword]
          end

          def mercari_crawl_setting_required_keyword_params
            params.permit(mercari_crawl_setting_required_keyword_attributes)
          end
        end
      end
    end
  end
end
