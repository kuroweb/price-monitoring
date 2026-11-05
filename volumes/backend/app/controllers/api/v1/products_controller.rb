module Api
  module V1
    class ProductsController < Api::ApplicationController # rubocop:disable Metrics/ClassLength
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

      def upsert_product_params # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        params.permit(
          product_attributes + [
            yahoo_auction_crawl_setting: yahoo_auction_crawl_setting_attributes + [
              {
                yahoo_auction_crawl_setting_exclude_keywords: yahoo_auction_crawl_setting_exclude_keyword_attributes,
                yahoo_auction_crawl_setting_required_keywords: yahoo_auction_crawl_setting_required_keyword_attributes
              }
            ],
            mercari_crawl_setting: mercari_crawl_setting_attributes + [
              {
                mercari_crawl_setting_exclude_keywords: mercari_crawl_setting_exclude_keyword_attributes,
                mercari_crawl_setting_required_keywords: mercari_crawl_setting_required_keyword_attributes
              }
            ],
            janpara_crawl_setting: janpara_crawl_setting_attributes + [
              {
                janpara_crawl_setting_exclude_keywords: janpara_crawl_setting_exclude_keyword_attributes,
                janpara_crawl_setting_required_keywords: janpara_crawl_setting_required_keyword_attributes
              }
            ],
            iosys_crawl_setting: iosys_crawl_setting_attributes + [
              {
                iosys_crawl_setting_exclude_keywords: iosys_crawl_setting_exclude_keyword_attributes,
                iosys_crawl_setting_required_keywords: iosys_crawl_setting_required_keyword_attributes
              }
            ],
            pc_koubou_crawl_setting: pc_koubou_crawl_setting_attributes + [
              {
                pc_koubou_crawl_setting_exclude_keywords: pc_koubou_crawl_setting_exclude_keyword_attributes,
                pc_koubou_crawl_setting_required_keywords: pc_koubou_crawl_setting_required_keyword_attributes
              }
            ],
            used_sofmap_crawl_setting: used_sofmap_crawl_setting_attributes + [
              {
                used_sofmap_crawl_setting_exclude_keywords: used_sofmap_crawl_setting_exclude_keyword_attributes,
                used_sofmap_crawl_setting_required_keywords: used_sofmap_crawl_setting_required_keyword_attributes
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

      def mercari_crawl_setting_attributes
        %i[keyword category_id min_price max_price enabled]
      end

      def mercari_crawl_setting_exclude_keyword_attributes
        %i[keyword]
      end

      def mercari_crawl_setting_required_keyword_attributes
        %i[keyword]
      end

      def janpara_crawl_setting_attributes
        %i[keyword min_price max_price enabled]
      end

      def janpara_crawl_setting_exclude_keyword_attributes
        %i[keyword]
      end

      def janpara_crawl_setting_required_keyword_attributes
        %i[keyword]
      end

      def iosys_crawl_setting_attributes
        %i[keyword min_price max_price enabled]
      end

      def iosys_crawl_setting_exclude_keyword_attributes
        %i[keyword]
      end

      def iosys_crawl_setting_required_keyword_attributes
        %i[keyword]
      end

      def pc_koubou_crawl_setting_attributes
        %i[keyword min_price max_price enabled]
      end

      def pc_koubou_crawl_setting_exclude_keyword_attributes
        %i[keyword]
      end

      def pc_koubou_crawl_setting_required_keyword_attributes
        %i[keyword]
      end

      def used_sofmap_crawl_setting_attributes
        %i[keyword min_price max_price enabled]
      end

      def used_sofmap_crawl_setting_exclude_keyword_attributes
        %i[keyword]
      end

      def used_sofmap_crawl_setting_required_keyword_attributes
        %i[keyword]
      end

      def external_attributes
        %i[sort order]
      end
    end
  end
end
