class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= session[:user_info] if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    redirect_to "/auth/auth_provider", alert: "Please log in to continue"
  end
end
