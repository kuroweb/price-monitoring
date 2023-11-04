module Api
  module V1
    class UsersController < ApplicationController
      def index
        render json: { status: 200 }, status: 200
      end

      def create; end

      def update; end

      def destroy; end
    end
  end
end
