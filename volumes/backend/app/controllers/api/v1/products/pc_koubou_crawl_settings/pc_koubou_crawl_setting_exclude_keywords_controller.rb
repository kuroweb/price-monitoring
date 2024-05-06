module Api
  module V1
    module Products
      module PcKoubouCrawlSettings
        class PcKoubouCrawlSettingExcludeKeywordsController < ApplicationController
          def index
            render json: {
              pc_koubou_crawl_setting_exclude_keywords:
                product.pc_koubou_crawl_setting.pc_koubou_crawl_setting_exclude_keywords
            }, status: 200
          end

          def create
            pc_koubou_crawl_setting_exclude_keyword =
              product
              .pc_koubou_crawl_setting
              .pc_koubou_crawl_setting_exclude_keywords
              .build(pc_koubou_crawl_setting_exclude_keyword_params)

            if pc_koubou_crawl_setting_exclude_keyword.save
              render json: pc_koubou_crawl_setting_exclude_keyword.as_json, status: 200
            else
              render json: { message: pc_koubou_crawl_setting_exclude_keyword.errors.full_messages }, status: 400
            end
          end

          def update
            pc_koubou_crawl_setting_exclude_keyword =
              product
              .pc_koubou_crawl_setting
              .pc_koubou_crawl_setting_exclude_keywords
              .find(params[:id])

            pc_koubou_crawl_setting_exclude_keyword.assign_attributes(
              pc_koubou_crawl_setting_exclude_keyword_params
            )

            if pc_koubou_crawl_setting_exclude_keyword.save
              render json: pc_koubou_crawl_setting_exclude_keyword.as_json, status: 200
            else
              render json: { message: pc_koubou_crawl_setting_exclude_keyword.errors.full_messages }, status: 400
            end
          end

          def destroy
            pc_koubou_crawl_setting_exclude_keyword =
              product
              .pc_koubou_crawl_setting
              .pc_koubou_crawl_setting_exclude_keywords
              .find(params[:id])

            if pc_koubou_crawl_setting_exclude_keyword.destroy
              head 200
            else
              render json: { message: result.message }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def pc_koubou_crawl_setting_exclude_keyword_attributes
            %i[keyword]
          end

          def pc_koubou_crawl_setting_exclude_keyword_params
            params.permit(pc_koubou_crawl_setting_exclude_keyword_attributes)
          end
        end
      end
    end
  end
end
