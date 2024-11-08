module Api
  class ApplicationController < ActionController::API
    # NOTE: rescue_fromは下側から順に評価される
    rescue_from StandardError, with: :internal_server_error
    rescue_from ActiveRecord::RecordInvalid, with: :bad_request_error
    rescue_from ActiveRecord::RecordNotUnique, with: :conflict_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

    def internal_server_error(exception)
      Bugsnag.notify(exception)
      Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
      render json: build_error_json(503, "Internal Server Error.", []), status: :service_unavailable
    end

    def bad_request_error
      render json: build_error_json(400, "Bad Request.", []), status: :bad_request
    end

    def conflict_error
      render json: build_error_json(409, "Conflict.", []), status: :conflict
    end

    def not_found_error
      render json: build_error_json(404, "Not Found.", []), status: :not_found
    end

    def build_error_json(code, message, details)
      {
        error: {
          code:,
          message:,
          details:
        }
      }
    end
  end
end
