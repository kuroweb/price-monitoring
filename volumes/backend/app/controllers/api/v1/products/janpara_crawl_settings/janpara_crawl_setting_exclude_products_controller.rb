module Api
  module V1
    module Products
      module JanparaCrawlSettings
        class JanparaCrawlSettingExcludeProductsController < ApplicationController
          def index
            render json: {
              janpara_crawl_setting_exclude_products:
                product.janpara_crawl_setting.janpara_crawl_setting_exclude_products
            }, status: 200
          end

          def create
            janpara_crawl_setting_exclude_product =
              product
              .janpara_crawl_setting
              .janpara_crawl_setting_exclude_products
              .create!(janpara_crawl_setting_exclude_product_params)

            render json: janpara_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            janpara_crawl_setting_exclude_product.update!(janpara_crawl_setting_exclude_product_params)
            render json: janpara_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if janpara_crawl_setting_exclude_product.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def janpara_crawl_setting_exclude_product
            @janpara_crawl_setting_exclude_product ||=
              product
              .janpara_crawl_setting
              .janpara_crawl_setting_exclude_products
              .find(params[:id])
          end

          def janpara_crawl_setting_exclude_product_attributes
            %i[external_id]
          end

          def janpara_crawl_setting_exclude_product_params
            params.permit(janpara_crawl_setting_exclude_product_attributes)
          end
        end
      end
    end
  end
end
