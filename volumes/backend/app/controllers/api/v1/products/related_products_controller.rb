module Api
  module V1
    module Products
      class RelatedProductsController < ApplicationController
        def index
          render json: { related_products: Search::RetrieveRelatedProduct.call(params: search_params) },
                 status: 200
        end

        private

        def product
          @product ||= Product.find(params[:product_id])
        end

        def search_params
          params.permit(:product_id, :published, :page, :per, :sort, :order)
        end
      end
    end
  end
end
