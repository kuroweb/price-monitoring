module Api
  module V1
    module Products
      module JanparaCrawlSettings
        class JanparaCrawlSettingRequiredKeywordsController < ApplicationController
          def index
            render json: {
              janpara_crawl_setting_required_keywords:
                product.janpara_crawl_setting.janpara_crawl_setting_required_keywords
            }, status: 200
          end

          def create
            janpara_crawl_setting_required_keyword =
              product
              .janpara_crawl_setting
              .janpara_crawl_setting_required_keywords
              .create!(janpara_crawl_setting_required_keyword_params)

            inspect
            render json: janpara_crawl_setting_required_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def update
            janpara_crawl_setting_required_keyword.update!(janpara_crawl_setting_required_keyword_params)
            inspect
            render json: janpara_crawl_setting_required_keyword.as_json, status: 200
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Bad Request. exception: #{e.full_message}")
            render json: { error: "Bad Request.", status: 400 }, status: 400
          end

          def destroy
            if janpara_crawl_setting_required_keyword.destroy
              head 200
            else
              render json: { error: "Bad Request.", status: 400 }, status: 400
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def janpara_crawl_setting_required_keyword
            @janpara_crawl_setting_required_keyword ||=
              product
              .janpara_crawl_setting
              .janpara_crawl_setting_required_keywords
              .find(params[:id])
          end

          def janpara_crawl_setting_required_keyword_attributes
            %i[keyword]
          end

          def janpara_crawl_setting_required_keyword_params
            params.permit(janpara_crawl_setting_required_keyword_attributes)
          end

          def inspect
            ::Products::Inspect::DeleteJanparaProducts.call(product:)
          end
        end
      end
    end
  end
end
