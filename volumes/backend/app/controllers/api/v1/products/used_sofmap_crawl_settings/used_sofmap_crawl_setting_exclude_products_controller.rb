module Api
  module V1
    module Products
      module UsedSofmapCrawlSettings
        class UsedSofmapCrawlSettingExcludeProductsController < ApplicationController
          def index
            render json: {
              used_sofmap_crawl_setting_exclude_products:
                product.used_sofmap_crawl_setting.used_sofmap_crawl_setting_exclude_products
            }, status: 200
          end

          def create
            used_sofmap_crawl_setting_exclude_product =
              product
              .used_sofmap_crawl_setting
              .used_sofmap_crawl_setting_exclude_products
              .create!(used_sofmap_crawl_setting_exclude_product_params)

            inspect
            render json: used_sofmap_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            used_sofmap_crawl_setting_exclude_product.update!(used_sofmap_crawl_setting_exclude_product_params)
            inspect
            render json: used_sofmap_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if used_sofmap_crawl_setting_exclude_product.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def used_sofmap_crawl_setting_exclude_product
            @used_sofmap_crawl_setting_exclude_product ||=
              product
              .used_sofmap_crawl_setting
              .used_sofmap_crawl_setting_exclude_products
              .find(params[:id])
          end

          def used_sofmap_crawl_setting_exclude_product_attributes
            %i[external_id]
          end

          def used_sofmap_crawl_setting_exclude_product_params
            params.permit(used_sofmap_crawl_setting_exclude_product_attributes)
          end

          def inspect
            ::Products::Inspect::DeleteUsedSofmapProducts.call(product:)
          end
        end
      end
    end
  end
end
