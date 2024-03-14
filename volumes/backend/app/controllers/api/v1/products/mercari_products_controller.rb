module Api
  module V1
    module Products
      class MercariProductsController < ApplicationController
        def index
          mercari_products = MercariProductFinder.new(params: mercari_product_params).execute
          render json: { mercari_products: }, status: 200
        end

        def show
          mercari_product = MercariProduct.find_by!(id: params[:id])
          render json: mercari_product, status: 200
        end

        def create; end

        def update; end

        def destroy; end

        private

        def mercari_product_params_attributes
          %i[id product_id mercari_id name price published]
        end

        def mercari_product_params
          @mercari_product_params ||= params.permit(mercari_product_params_attributes)
        end
      end
    end
  end
end
