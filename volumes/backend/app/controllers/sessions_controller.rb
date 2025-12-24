# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    # OmniAuthからユーザー情報を取得
    auth = request.env["omniauth.auth"]

    # デバッグ用ログ
    Rails.logger.info("OmniAuth Auth: #{auth.inspect}")

    # ユーザー情報を取得
    user_info = {
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      name: auth.info.name
    }

    # セッションに保存
    session[:user_id] = auth.uid
    session[:user_info] = user_info
    session[:access_token] = auth.credentials.token
    session[:refresh_token] = auth.credentials.refresh_token
    session[:expires_at] = auth.credentials.expires_at

    Rails.logger.info("Session created for user: #{user_info[:email]}")

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
    user_email = session.dig(:user_info, :email)

    # TODO: OPのトークン無効化（将来実装）
    # if session[:access_token]
    #   revoke_token(session[:access_token])
    # end

    reset_session

    Rails.logger.info("Session destroyed for user: #{user_email}")
    redirect_to "/auth/test", notice: "Logged out successfully"
  end

  private

  # TODO: 将来実装
  # def revoke_token(token)
  #   uri = URI("#{ENV['OIDC_ISSUER']}/oauth/revoke")
  #   response = Net::HTTP.post_form(uri,
  #     'token' => token,
  #     'client_id' => ENV['OIDC_CLIENT_ID'],
  #     'client_secret' => ENV['OIDC_CLIENT_SECRET']
  #   )
  #   Rails.logger.info("Token revocation response: #{response.code}")
  # end
end
