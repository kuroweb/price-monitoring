module Api
  module V1
    class ApplicationController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound, with: :error_not_found

      def error_not_found
        render json: { error: "not found", status: 404 }, status: :not_found
      end
    end
  end
end
