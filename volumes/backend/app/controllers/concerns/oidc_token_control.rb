module OidcTokenControl
  extend ActiveSupport::Concern

  OIDC_TOKEN_EXPIRATION = 5.minutes

  private

  def auto_refresh_oidc_token
    refresh_oidc_token! if oidc_refreshable?
  rescue StandardError => e
    Rails.logger.error("Error refreshing OIDC token: #{e.message}")
    reset_session
    redirect_to "/auth/auth_provider", alert: "Your session has expired. Please log in again."
  end

  def refresh_oidc_token!
    Retryable.retryable(
      {
        tries: 3,
        on: [Faraday::TimeoutError, Faraday::ConnectionFailed],
        sleep: ->(n) { 2**n }
      }
    ) do
      response = request_oidc_refresh
      handle_oidc_refresh(response)
    end
  end

  def request_oidc_refresh
    oidc_http_client.post(
      "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/token",
      {
        grant_type: "refresh_token",
        refresh_token: session[:refresh_token],
        client_id: ENV.fetch("OIDC_CLIENT_ID", nil),
        client_secret: ENV.fetch("OIDC_CLIENT_SECRET", nil)
      }
    )
  end

  def oidc_http_client
    Faraday.new(
      ssl: Rails.env.development? ? { verify: false } : {}
    ) do |conn|
      conn.request :url_encoded
      conn.adapter Faraday.default_adapter
      conn.options.timeout = 10
    end
  end

  def handle_oidc_refresh(response)
    unless response.success?
      Rails.logger.error("Failed to refresh token: #{response.status} - #{response.body}")
      raise "Token refresh failed: #{response.status}"
    end

    update_oidc_session(JSON.parse(response.body))
  end

  def update_oidc_session(body)
    session[:access_token] = body["access_token"]
    session[:refresh_token] = body["refresh_token"]
    session[:expires_at] = Time.current.to_i + body["expires_in"]
  end

  def oidc_refreshable?
    oidc_expiring_soon? && session[:refresh_token].present?
  end

  def oidc_expiring_soon?
    return false if session[:expires_at].blank?

    Time.current.to_i >= (session[:expires_at] - OIDC_TOKEN_EXPIRATION.to_i)
  end
end
