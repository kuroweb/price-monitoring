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
          params.permit(%i[product_id platform_mask page per sort order])
        end
      end
    end
  end
end
