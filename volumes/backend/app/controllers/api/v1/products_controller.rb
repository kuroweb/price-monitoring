module Api
  module V1
    class ProductsController < Api::ApplicationController
      def index
        products = ProductFinder.new(params: find_product_params).execute
        render json: Api::ProductListSerializer.new(products).as_json, status: :ok
      end

      def show
        render json: Api::ProductDetailSerializer.new(product).as_json, status: :ok
      end

      def create
        product = ::Products::Creator::CreateProduct.call(params: upsert_product_params)
        render json: product.as_json, status: :ok
      end

      def update
        ::Products::Updater::UpdateProduct.call(product:, params: upsert_product_params)
        ::Products::Inspector::InspectAll.call(product:)
        render json: product.as_json, status: :ok
      end

      def destroy
        if product.destroy
          render json: {}, status: :ok
        else
          render json: build_error_json(400, "Bad Request.", []), status: :bad_request
        end
      end

      private

      def product
        @product ||= Product.find(params[:id])
      end

      def find_product_params
        params.permit(product_attributes + external_attributes)
      end

      def upsert_product_params
        params.permit(
          product_attributes + [
            yahoo_auction_crawl_setting: yahoo_auction_crawl_setting_attributes + [
              {
                yahoo_auction_crawl_setting_exclude_keywords: yahoo_auction_crawl_setting_exclude_keyword_attributes,
                yahoo_auction_crawl_setting_required_keywords: yahoo_auction_crawl_setting_required_keyword_attributes
              }
            ]
          ] + [:category_id]
        )
      end

      def product_attributes
        %i[name]
      end

      def yahoo_auction_crawl_setting_attributes
        %i[keyword category_id min_price max_price enabled]
      end

      def yahoo_auction_crawl_setting_exclude_keyword_attributes
        %i[keyword]
      end

      def yahoo_auction_crawl_setting_required_keyword_attributes
        %i[keyword]
      end

      def external_attributes
        %i[sort order]
      end
    end
  end
end
