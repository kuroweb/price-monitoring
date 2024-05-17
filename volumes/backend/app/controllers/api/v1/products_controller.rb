module Api
  module V1
    class ProductsController < ApplicationController
      def index
        products = ProductFinder.new(params: find_product_params).execute
        render json: { products: products.as_json }, status: 200
      end

      def show
        render json: product.as_json, status: 200
      end

      def create
        product = ::Products::Create.call(params: create_product_params)
        inspect
        render json: product.as_json, status: 200
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("Bad Request. exception: #{e.full_message}")
        render json: { error: "Bad Request.", status: 400 }, status: 400
      end

      def update
        ::Products::Update.call(product:, params: update_product_params)
        inspect
        render json: product.as_json, status: 200
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("Bad Request. exception: #{e.full_message}")
        render json: { error: "Bad Request.", status: 400 }, status: 400
      end

      def destroy
        if product.destroy
          head 200
        else
          render json: { error: "Bad Request.", status: 400 }, status: 400
        end
      end

      private

      def product
        @product ||= Product.find(params[:id])
      end

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

      def pc_koubou_crawl_setting_attributes
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
          janpara_crawl_setting: janpara_crawl_setting_attributes,
          iosys_crawl_setting: iosys_crawl_setting_attributes,
          pc_koubou_crawl_setting: pc_koubou_crawl_setting_attributes
        )
      end

      def update_product_params
        @update_product_params ||= params.permit(
          product_attributes,
          yahoo_auction_crawl_setting: yahoo_auction_crawl_setting_attributes,
          mercari_crawl_setting: mercari_crawl_setting_attributes,
          janpara_crawl_setting: janpara_crawl_setting_attributes,
          iosys_crawl_setting: iosys_crawl_setting_attributes,
          pc_koubou_crawl_setting: pc_koubou_crawl_setting_attributes
        )
      end

      def inspect
        ::Products::Inspect::DeleteYahooAuctionProducts.call(product:)
        ::Products::Inspect::DeleteYahooFleamarketProducts.call(product:)
        ::Products::Inspect::DeleteMercariProducts.call(product:)
        ::Products::Inspect::DeleteJanparaProducts.call(product:)
        ::Products::Inspect::DeleteIosysProducts.call(product:)
        ::Products::Inspect::DeletePcKoubouProducts.call(product:)
      end
    end
  end
end
