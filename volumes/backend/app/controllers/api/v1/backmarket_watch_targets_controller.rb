module Api
  module V1
    class BackmarketWatchTargetsController < Api::ApplicationController
      before_action :set_backmarket_watch_target, only: %i[update destroy]

      def index
        backmarket_watch_targets = BackmarketWatchTarget.order(id: :desc)
        render json: Api::BackmarketWatchTargetListSerializer.new(backmarket_watch_targets).as_json, status: :ok
      end

      def create
        backmarket_watch_target = BackmarketWatchTarget.create!(upsert_params)
        render json: backmarket_watch_target.as_json, status: :ok
      end

      def update
        @backmarket_watch_target.update!(upsert_params)
        render json: @backmarket_watch_target.as_json, status: :ok
      end

      def destroy
        if @backmarket_watch_target.destroy
          render json: {}, status: :ok
        else
          render json: build_error_json(400, "Bad Request.", []), status: :bad_request
        end
      end

      private

      def upsert_params
        params.permit(:name, :url, :enabled)
      end

      def set_backmarket_watch_target
        @backmarket_watch_target = BackmarketWatchTarget.find(params[:id])
      end
    end
  end
end
