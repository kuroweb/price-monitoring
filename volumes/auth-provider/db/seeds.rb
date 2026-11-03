# ローカル開発の管理ユーザーと、BFF と同じ OIDC クライアントを用意する
return unless Rails.env.development?

client_id = ENV.fetch("OIDC_CLIENT_ID", "").presence or raise ArgumentError, "OIDC_CLIENT_ID is required"
client_secret = ENV.fetch("OIDC_CLIENT_SECRET", "").presence or raise ArgumentError, "OIDC_CLIENT_SECRET is required"
redirect_uri = ENV.fetch("OIDC_REDIRECT_URI", "").presence or raise ArgumentError, "OIDC_REDIRECT_URI is required"

User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name = "admin"
  user.password = "password"
  user.admin = true
end

Doorkeeper::Application.find_or_create_by!(uid: client_id) do |application|
  application.name = "price-monitoring"
  application.secret = client_secret
  application.redirect_uri = redirect_uri
  application.scopes = "openid email profile"
  application.confidential = true
end
