module Api
  module V1
    class BackmarketWatchResultsController < Api::ApplicationController
      def index
        backmarket_watch_targets = BackmarketWatchTarget.includes(:backmarket_watch_results).order(id: :desc)
        render json: Api::BackmarketWatchResultListSerializer.new(backmarket_watch_targets).as_json, status: :ok
      end
    end
  end
end
