module Api
  module V1
    module Products
      module MercariCrawlSettings
        class MercariCrawlSettingExcludeProductsController < ApplicationController
          def index
            render json: {
              mercari_crawl_setting_exclude_products:
                product.mercari_crawl_setting.mercari_crawl_setting_exclude_products
            }, status: 200
          end

          def create
            mercari_crawl_setting_exclude_product =
              product
              .mercari_crawl_setting
              .mercari_crawl_setting_exclude_products
              .create!(mercari_crawl_setting_exclude_product_params)

            render json: mercari_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            mercari_crawl_setting_exclude_product.update!(mercari_crawl_setting_exclude_product_params)
            render json: mercari_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if mercari_crawl_setting_exclude_product.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def mercari_crawl_setting_exclude_product
            @mercari_crawl_setting_exclude_product ||=
              product
              .mercari_crawl_setting
              .mercari_crawl_setting_exclude_products
              .find(params[:id])
          end

          def mercari_crawl_setting_exclude_product_attributes
            %i[external_id]
          end

          def mercari_crawl_setting_exclude_product_params
            params.permit(mercari_crawl_setting_exclude_product_attributes)
          end
        end
      end
    end
  end
end
