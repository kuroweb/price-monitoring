module Api
  module V1
    class CurrentUsersController < Api::ApplicationController
      def show
        user = User.find_by(id: session[:user_id]) if session[:user_id]
        render json: { current_user: user&.slice(:name, :email) }, status: :ok
      end
    end
  end
end
