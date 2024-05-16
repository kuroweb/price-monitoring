module Api
  module V1
    module Products
      class MercariProductsController < ApplicationController
        def index
          mercari_products = MercariProductFinder.new(params: mercari_product_params).execute
          render json: { mercari_products: }, status: 200
        end

        def show
          render json: mercari_product, status: 200
        end

        def create; end

        def update; end

        def destroy; end

        private

        def product
          @product ||= Product.find(params[:product_id])
        end

        def mercari_product
          @mercari_product ||= product.mercari_products.find(params[:id])
        end

        def mercari_product_params_attributes
          %i[id product_id external_id name price published]
        end

        def external_params_attributes
          %i[sort order]
        end

        def mercari_product_params
          @mercari_product_params ||=
            params.permit(mercari_product_params_attributes + external_params_attributes)
        end
      end
    end
  end
end
