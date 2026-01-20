class ApplicationController < ActionController::Base
  include OidcTokenControl

  before_action :auto_refresh_oidc_token, if: :logged_in?

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    redirect_to "/auth/auth_provider", alert: "Please log in to continue"
  end
end
