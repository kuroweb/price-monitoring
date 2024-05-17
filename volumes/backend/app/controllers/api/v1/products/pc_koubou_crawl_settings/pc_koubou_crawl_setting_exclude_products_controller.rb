module Api
  module V1
    module Products
      module PcKoubouCrawlSettings
        class PcKoubouCrawlSettingExcludeProductsController < ApplicationController
          def index
            render json: {
              pc_koubou_crawl_setting_exclude_products:
                product.pc_koubou_crawl_setting.pc_koubou_crawl_setting_exclude_products
            }, status: 200
          end

          def create
            pc_koubou_crawl_setting_exclude_product =
              product
              .pc_koubou_crawl_setting
              .pc_koubou_crawl_setting_exclude_products
              .create!(pc_koubou_crawl_setting_exclude_product_params)

            inspect
            render json: pc_koubou_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            pc_koubou_crawl_setting_exclude_product.update!(pc_koubou_crawl_setting_exclude_product_params)
            inspect
            render json: pc_koubou_crawl_setting_exclude_product.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if pc_koubou_crawl_setting_exclude_product.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def pc_koubou_crawl_setting_exclude_product
            @pc_koubou_crawl_setting_exclude_product ||=
              product
              .pc_koubou_crawl_setting
              .pc_koubou_crawl_setting_exclude_products
              .find(params[:id])
          end

          def pc_koubou_crawl_setting_exclude_product_attributes
            %i[external_id]
          end

          def pc_koubou_crawl_setting_exclude_product_params
            params.permit(pc_koubou_crawl_setting_exclude_product_attributes)
          end

          def inspect
            ::Products::Inspect::DeletePcKoubouProducts.call(product:)
          end
        end
      end
    end
  end
end
