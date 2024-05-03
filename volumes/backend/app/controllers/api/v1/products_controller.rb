module Api
  module V1
    class ProductsController < ApplicationController
      def index
        products = ProductFinder.new(params: find_product_params).execute
        render json: { products: products.as_json }, status: 200
      end

      def show
        products = ProductFinder.new(params: { id: params[:id] }).execute
        render json: products.first.as_json, status: 200
      end

      def create
        result = ::Products::Create.call(params: create_product_params)

        if result.success?
          render json: result.payload[:product].as_json, status: 200
        else
          render json: { message: result.message }, status: 400
        end
      end

      def update
        product = Product.find_by(id: params[:id])
        return head 404 if product.blank?

        result = ::Products::Update.call(product:, params: update_product_params)
        if result.success?
          render json: result.payload[:product].as_json, status: 200
        else
          render json: { message: result.message }, status: 400
        end
      end

      def destroy
        product = Product.find_by(id: params[:id])
        return head 404 if product.blank?

        result = ::Products::Delete.call(product:)
        if result.success?
          head 200
        else
          render json: { message: result.message }, status: 400
        end
      end

      private

      def product_attributes
        %i[id name]
      end

      def yahoo_auction_crawl_setting_attributes
        %i[keyword category_id min_price max_price enabled]
      end

      def mercari_crawl_setting_attributes
        %i[keyword category_id min_price max_price enabled]
      end

      def janpara_crawl_setting_attributes
        %i[keyword min_price max_price enabled]
      end

      def iosys_crawl_setting_attributes
        %i[keyword min_price max_price enabled]
      end

      def external_params_attributes
        %i[sort order]
      end

      def find_product_params
        @find_product_params ||= params.permit(product_attributes + external_params_attributes)
      end

      def create_product_params
        @create_product_params ||= params.permit(
          product_attributes,
          yahoo_auction_crawl_setting: yahoo_auction_crawl_setting_attributes,
          mercari_crawl_setting: mercari_crawl_setting_attributes,
          iosys_crawl_setting: iosys_crawl_setting_attributes,
          janpara_crawl_setting: janpara_crawl_setting_attributes
        )
      end

      def update_product_params
        @update_product_params ||= params.permit(
          product_attributes,
          yahoo_auction_crawl_setting: yahoo_auction_crawl_setting_attributes,
          mercari_crawl_setting: mercari_crawl_setting_attributes,
          janpara_crawl_setting: janpara_crawl_setting_attributes,
          iosys_crawl_setting: iosys_crawl_setting_attributes
        )
      end
    end
  end
end
