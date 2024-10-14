module Api
  class ApplicationController < ActionController::API
    # NOTE: rescue_fromは下側から順に評価される
    rescue_from StandardError, with: :internal_server_error
    rescue_from ActiveRecord::RecordNotUnique, with: :conflict_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

    def internal_server_error(exception)
      BugSnag.notify(exception)
      Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
      render json: { error: "Internal Server Error.", status: 503 }, status: :service_unavailable
    end

    def conflict_error
      render json: { error: "Conflict.", status: 409 }, status: :conflict
    end

    def not_found_error
      render json: { error: "Not Found.", status: 404 }, status: :not_found
    end
  end
end
