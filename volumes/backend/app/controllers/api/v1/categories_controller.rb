module Api
  module V1
    class CategoriesController < Api::ApplicationController
      def index
        categories = CategoryFinder.new(params: find_category_params).execute
        render json: { categories: }, status: :ok
      end

      private

      def find_category_params
        params.permit(category_attributes + external_attributes)
      end

      def category_attributes
        %i[name]
      end

      def external_attributes
        %i[root_only]
      end
    end
  end
end
