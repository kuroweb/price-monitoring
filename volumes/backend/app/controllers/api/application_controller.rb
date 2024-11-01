module Api
  class ApplicationController < ActionController::API
    # NOTE: rescue_fromは下側から順に評価される
    rescue_from StandardError, with: :internal_server_error
    rescue_from ActiveRecord::RecordNotUnique, with: :conflict_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

    def internal_server_error(exception)
      Bugsnag.notify(exception)
      Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
      render json: { code: 503, message: "Internal Server Error.", details: [] }, status: :service_unavailable
    end

    def conflict_error
      render json: { code: 409, message: "Conflict.", details: [] }, status: :conflict
    end

    def not_found_error
      render json: { code: 404, message: "Not Found.", details: [] }, status: :not_found
    end
  end
end
