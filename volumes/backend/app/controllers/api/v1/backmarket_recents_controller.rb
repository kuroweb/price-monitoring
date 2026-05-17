module Api
  module V1
    class BackmarketRecentsController < Api::ApplicationController
      def index
        render json: Api::BackmarketRecentListSerializer.new.as_json, status: :ok
      end
    end
  end
end
