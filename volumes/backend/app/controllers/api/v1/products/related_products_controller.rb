module Api
  module V1
    module Products
      class RelatedProductsController < ApplicationController
        def index
          related_products = Search::RetrieveRelatedProduct.call(params: search_params)
          render json: { related_products: related_products.products.map(&:attributes) },
                 status: 200
        end

        private

        def product
          @product ||= Product.find(params[:product_id])
        end

        def search_params
          params.permit(
            %i[product_id platform_mask published yahoo_auction_buyable page per sort order]
          ).tap do |p|
            p[:published] = params[:published] == "true"
            p[:yahoo_auction_buyable] = params[:yahoo_auction_buyable] == "true"
          end
        end
      end
    end
  end
end
