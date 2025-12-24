OmniAuth.config.allowed_request_methods = %i[get post]

# 開発環境では自己証明書のSSL検証をスキップ
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
    issuer: ENV.fetch("OIDC_ISSUER"),
    discovery: true,
    client_options: {
      identifier: ENV.fetch("OIDC_CLIENT_ID"),
      secret: ENV.fetch("OIDC_CLIENT_SECRET"),
      redirect_uri: ENV.fetch("OIDC_REDIRECT_URI")
    }
  }
end
