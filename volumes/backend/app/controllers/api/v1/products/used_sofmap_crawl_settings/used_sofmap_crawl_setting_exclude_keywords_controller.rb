module Api
  module V1
    module Products
      module UsedSofmapCrawlSettings
        class UsedSofmapCrawlSettingExcludeKeywordsController < ApplicationController
          def index
            render json: {
              used_sofmap_crawl_setting_exclude_keywords:
                product.used_sofmap_crawl_setting.used_sofmap_crawl_setting_exclude_keywords
            }, status: 200
          end

          def create
            used_sofmap_crawl_setting_exclude_keyword =
              product
              .used_sofmap_crawl_setting
              .used_sofmap_crawl_setting_exclude_keywords
              .create!(used_sofmap_crawl_setting_exclude_keyword_params)

            inspect
            render json: used_sofmap_crawl_setting_exclude_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            used_sofmap_crawl_setting_exclude_keyword.update!(used_sofmap_crawl_setting_exclude_keyword_params)
            inspect
            render json: used_sofmap_crawl_setting_exclude_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if used_sofmap_crawl_setting_exclude_keyword.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def used_sofmap_crawl_setting_exclude_keyword
            @used_sofmap_crawl_setting_exclude_keyword ||=
              product
              .used_sofmap_crawl_setting
              .used_sofmap_crawl_setting_exclude_keywords
              .find(params[:id])
          end

          def used_sofmap_crawl_setting_exclude_keyword_attributes
            %i[keyword]
          end

          def used_sofmap_crawl_setting_exclude_keyword_params
            params.permit(used_sofmap_crawl_setting_exclude_keyword_attributes)
          end

          def inspect
            ::Products::Inspect::DeleteUsedSofmapProducts.call(product:)
          end
        end
      end
    end
  end
end
