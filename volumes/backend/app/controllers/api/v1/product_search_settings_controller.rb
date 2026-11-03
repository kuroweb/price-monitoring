module Api
  module V1
    class ProductSearchSettingsController < Api::ApplicationController
      rescue_from ArgumentError, with: :invalid_settings

      def index
        products = Product.joins(:search_urls).distinct.includes(:search_urls, :required_keywords, :exclude_keywords, :excluded_listings).order(:id)
        render json: { products: products.map { |product| Api::ProductSearchSettingsSerializer.new(product).as_json } }
      end

      def create
        product = ::Products::SearchSettingsWriter.call(product: Product.new, params: settings_params)
        render json: Api::ProductSearchSettingsSerializer.new(product).as_json
      end

      def update
        product = ::Products::SearchSettingsWriter.call(product: Product.find(params[:id]), params: settings_params)
        render json: Api::ProductSearchSettingsSerializer.new(product).as_json
      end

      def preview
        render json: Crawl::Search::Preview.call(params: settings_params)
      end

      private

      def settings_params
        params.permit(:name, :enabled, :min_price, :max_price, required_keywords: [], exclude_keywords: [], excluded_listings: %i[platform external_id], urls: %i[url enabled])
      end

      def invalid_settings(error)
        render json: build_error_json(400, error.message, []), status: :bad_request
      end
    end
  end
end
