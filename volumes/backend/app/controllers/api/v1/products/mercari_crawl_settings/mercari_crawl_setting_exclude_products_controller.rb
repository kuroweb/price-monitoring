module Api
  module V1
    module Products
      module UsedSofmapCrawlSettings
        class UsedSofmapCrawlSettingExcludeProductsController < Api::ApplicationController
          def index
            render json: {
              used_sofmap_crawl_setting_exclude_products: exclude_products
            }, status: :ok
          end

          def create
            exclude_product = exclude_products.create!(exclude_product_params)
            inspect
            render json: exclude_product.as_json, status: :ok
          end

          def destroy
            if exclude_product.destroy
              render json: {}, status: :ok
            else
              render json: build_error_json(400, "Bad Request.", []), status: :bad_request
            end
          end

          private

          def product
            @product ||= Product.find(params[:product_id])
          end

          def exclude_keyword
            @exclude_keyword ||= exclude_products.find(params[:id])
          end

          def exclude_products
            @exclude_products ||= product.used_sofmap_crawl_setting
                                         .used_sofmap_crawl_setting_exclude_products
          end

          def exclude_product_params
            params.permit(exclude_product_attributes)
          end

          def exclude_product_attributes
            %i[external_id]
          end

          def inspect
            ::Products::Inspect::DeleteYahooAuctionProducts.call(product:)
            ::Products::Inspect::DeleteYahooFleamarketProducts.call(product:)
            ::Products::Inspect::DeleteMercariProducts.call(product:)
            ::Products::Inspect::DeleteJanparaProducts.call(product:)
            ::Products::Inspect::DeleteIosysProducts.call(product:)
            ::Products::Inspect::DeletePcKoubouProducts.call(product:)
            ::Products::Inspect::DeleteUsedSofmapProducts.call(product:)
          end
        end
      end
    end
  end
end
