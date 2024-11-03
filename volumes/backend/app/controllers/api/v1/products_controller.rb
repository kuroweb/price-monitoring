module Api
  module V1
    class ProductsController < Api::ApplicationController
      def index
        products = ProductFinder.new(params: find_product_params).execute
        render json: ProductsSerializer.new(products), status: :ok
      end

      def create
        product = ::Products::Create.call(params: create_product_params)
        render json: ProductSerializer.new(product), status: :ok
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("Bad Request. exception: #{e.full_message}")
        render json: { code: 400, message: "Bad Request.", details: [] }, status: :bad_request
      end

      def destroy
        product = Product.find(params[:id])

        if product.destroy
          render json: {}, status: :ok
        else
          render json: build_error_json(500, "Bad Request.", []), status: :bad_request
        end
      end

      private

      def find_product_params
        params.permit(product_attributes + external_attributes)
      end

      def create_product_params
        params.permit(
          product_attributes + [
            yahoo_auction_crawl_setting: yahoo_auction_crawl_setting_attributes,
            mercari_crawl_setting: mercari_crawl_setting_attributes,
            janpara_crawl_setting: janpara_crawl_setting_attributes,
            iosys_crawl_setting: iosys_crawl_setting_attributes,
            pc_koubou_crawl_setting: pc_koubou_crawl_setting_attributes,
            used_sofmap_crawl_setting: used_sofmap_crawl_setting_attributes
          ] + [:category_id]
        )
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

      def used_sofmap_crawl_setting_attributes
        %i[keyword min_price max_price enabled]
      end

      def external_attributes
        %i[sort order]
      end
    end
  end
end
