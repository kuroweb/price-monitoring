module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = UserFinder.new(params: user_params).execute
        render json: { users: users.as_json }, status: 200
      end

      def show
        users = UserFinder.new(params: { id: params[:id] }).execute
        render json: users.first.as_json, status: 200
      end

      def create; end

      def update; end

      def destroy; end

      private

      def user_params_attributes
        %i[id name]
      end

      def user_params
        @user_params ||= params.require(:user).permit(user_params_attributes)
      end
    end
  end
end
