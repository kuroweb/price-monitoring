module Api
  module V1
    class ProductsController < Api::ApplicationController
      def index
        products = ProductFinder.new(params: find_product_params).execute
        render json: Api::Products::ProductListSerializer.new(products), status: :ok
      end

      def show
        render json: Api::Products::ProductDetailSerializer.new(product), status: :ok
      end

      def create
        product = ::Products::Create.call(params: create_product_params)
        render json: Api::Products::ProductDetailSerializer.new(product), status: :ok
      end

      def update
        ::Products::Update.call(product:, params: update_product_params)
        inspect
        render json: Api::Products::ProductDetailSerializer.new(product), status: :ok
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

      def update_product_params
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
