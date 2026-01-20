# frozen_string_literal: true

class SessionsController < ApplicationController
  include OidcTokenControl

  skip_before_action :verify_authenticity_token, only: [:create]

  def create # rubocop:disable Metrics/AbcSize
    auth = request.env["omniauth.auth"]
    user_info = {
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      name: auth.info.name
    }

    reset_session

    session[:user_id] = auth.uid
    session[:user_info] = user_info
    session[:access_token] = auth.credentials.token
    session[:refresh_token] = auth.credentials.refresh_token
    session[:expires_at] = Time.current.to_i + auth.credentials.expires_in

    # TODO: 実際のユーザーモデルと連携する場合
    # user = User.find_or_create_by(email: auth.info.email) do |u|
    #   u.name = auth.info.name if auth.info.name
    # end
    # session[:user_id] = user.id

    redirect_to "/auth/test", notice: "Logged in successfully as #{user_info[:email]}"
  end

  def failure
    error_message = params[:message] || "Unknown error"
    Rails.logger.error("Authentication failed: #{error_message}")
    redirect_to "/auth/test", alert: "Authentication failed: #{error_message}"
  end

  def destroy
    revoke_tokens if session[:access_token].present?
    reset_session
    redirect_to "/auth/test", notice: "Logged out successfully"
  rescue StandardError => e
    Bugsnag.notify(e)
    reset_session
    redirect_to "/auth/test", notice: "Logged out successfully"
  end

  private

  def revoke_tokens
    revoke_token(session[:access_token], "access_token")
    revoke_token(session[:refresh_token], "refresh_token") if session[:refresh_token].present?
  end

  def revoke_token(token, token_type_hint)
    oidc_http_client.post(
      "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke",
      {
        token: token,
        token_type_hint: token_type_hint,
        client_id: ENV.fetch("OIDC_CLIENT_ID", nil),
        client_secret: ENV.fetch("OIDC_CLIENT_SECRET", nil)
      }
    )
  end
end
