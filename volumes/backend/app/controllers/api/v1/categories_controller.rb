module Api
  module V1
    class CategoriesController < Api::ApplicationController
      before_action :set_category, only: %i[show structured_subtree update destroy]

      def index
        categories = CategoryFinder.new(
          params: { name: index_params[:name],
                    root_only: index_params[:root_only] == "true" }
        ).execute

        render json: { categories: }, status: :ok
      end

      def show
        render json: @category, status: :ok
      end

      def structured
        categories = CategoryFinder.new(
          params: { name: structured_params[:name], root_only: true }
        ).execute

        render json: {
          categories: CategoryStructuredSerializer.new(categories).as_json
        }, status: :ok
      end

      def structured_subtree
        render json: CategoryStructuredSubtreeSerializer.new(@category).as_json, status: :ok
      end

      def create
        category = ::Categories::Creator.call(params: create_params)
        render json: category.as_json, status: :ok
      end

      def update
        ::Categories::Updater.call(category: @category, params: update_params)
        render json: @category.as_json, status: :ok
      end

      def destroy
        if @category.destroy
          render json: {}, status: :ok
        else
          render json: build_error_json(400, "Bad Request.", []), status: :bad_request
        end
      end

      private

      def index_params
        params.permit(:name, :root_only)
      end

      def show_params
        params.permit(:id)
      end

      def structured_params
        params.permit(:name)
      end

      def create_params
        params.permit(:parent_id, :name)
      end

      def update_params
        params.permit(:parent_id, :name)
      end

      def set_category
        @category = Category.find(params[:id])
      end
    end
  end
end
