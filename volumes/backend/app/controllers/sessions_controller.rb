# frozen_string_literal: true

class SessionsController < ApplicationController
  include OidcTokenControl

  skip_before_action :verify_authenticity_token, only: [:create]

  def create # rubocop:disable Metrics/AbcSize
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_by!(
      provider_name: User::ProviderName::AUTH_PROVIDER,
      provider_uid: auth.uid
    ) do |u|
      u.name = auth.info.name
      u.email = auth.info.email
    end

    reset_session
    session[:user_id] = user.id
    session[:access_token] = auth.credentials.token
    session[:refresh_token] = auth.credentials.refresh_token
    session[:expires_at] = Time.current.to_i + auth.credentials.expires_in
    session[:id_token] = auth.credentials.id_token

    redirect_to "/"
  end

  def failure
    error_message = params[:message] || "Unknown error"
    Rails.logger.error("Authentication failed: #{error_message}")
    redirect_to "/products?auth_error=1"
  end

  def csrf_token
    response.headers["Cache-Control"] = "no-store"
    render json: { csrf_token: form_authenticity_token }
  end

  def destroy
    logout_url = provider_logout_url
    begin
      revoke_tokens if session[:access_token].present?
    rescue StandardError => e
      Bugsnag.notify(e)
    end
    reset_session

    # frontend は server action から呼ぶため、ブラウザを移す先を JSON で受け取る
    respond_to do |format|
      format.json { render json: { logout_url: } }
      format.any { redirect_to logout_url, allow_other_host: true, status: :see_other }
    end
  end

  private

  # Provider のセッションも終了するため、Provider のログアウトを経てアプリのトップへ戻す
  def provider_logout_url
    # ID トークンを持たない古いセッションは Provider がログアウトを受け付けないので、トップへ戻すだけにする
    return "/" if session[:id_token].blank?

    query = {
      id_token_hint: session[:id_token],
      post_logout_redirect_uri: URI.join(ENV.fetch("OIDC_REDIRECT_URI", nil), "/").to_s
    }.to_query
    "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/logout?#{query}"
  end

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
