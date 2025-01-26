module Api
  module V1
    class CategoriesController < Api::ApplicationController
      def index
        categories = CategoryFinder.new(params: finder_params).execute
        render json: {
          categories: CategoryListSerializer.new(categories, permitted_params[:display_depth_limit]).as_json
        }, status: :ok
      end

      def show
        category = Category.find(params[:id])
        render json: CategoryDetailSerializer.new(category, permitted_params[:display_depth_limit]).as_json,
               status: :ok
      end


      private

      def permitted_params
        params.permit(:name, :root_only, :display_depth_limit)
      end

      def finder_params
        {
          name: permitted_params[:name],
          root_only: permitted_params[:root_only] == "true"
        }
      end
    end
  end
end
