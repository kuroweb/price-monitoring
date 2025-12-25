OmniAuth.config.allowed_request_methods = %i[get post]

if Rails.env.development?
  OpenIDConnect.http_config do |config|
    config.ssl.verify = false
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid_connect, {
    name: :auth_provider,
    scope: %i[openid email profile],
    response_type: :code,
    issuer: ENV.fetch("OIDC_ISSUER", nil),
    discovery: true,
    client_options: {
      identifier: ENV.fetch("OIDC_CLIENT_ID", nil),
      secret: ENV.fetch("OIDC_CLIENT_SECRET", nil),
      redirect_uri: ENV.fetch("OIDC_REDIRECT_URI", nil)
    }
  }
end
