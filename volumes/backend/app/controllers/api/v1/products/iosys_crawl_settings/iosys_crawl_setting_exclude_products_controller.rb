module Api
  module V1
    module Products
      module IosysCrawlSettings
        class IosysCrawlSettingExcludeProductsController < ApplicationController
          def index
            render json: {
              iosys_crawl_setting_exclude_products:
                product.iosys_crawl_setting.iosys_crawl_setting_exclude_products
            }, status: 200
          end

          def create
            iosys_crawl_setting_exclude_product =
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_exclude_products
              .create!(iosys_crawl_setting_exclude_product_params)

            inspect
            render json: iosys_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            iosys_crawl_setting_exclude_product.update!(iosys_crawl_setting_exclude_product_params)
            inspect
            render json: iosys_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if iosys_crawl_setting_exclude_product.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def iosys_crawl_setting_exclude_product
            @iosys_crawl_setting_exclude_product ||=
              product
              .iosys_crawl_setting
              .iosys_crawl_setting_exclude_products
              .find(params[:id])
          end

          def iosys_crawl_setting_exclude_product_attributes
            %i[external_id]
          end

          def iosys_crawl_setting_exclude_product_params
            params.permit(iosys_crawl_setting_exclude_product_attributes)
          end

          def inspect
            ::Products::Inspect::DeleteIosysProducts.call(product:)
          end
        end
      end
    end
  end
end
