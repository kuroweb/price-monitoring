# ローカル開発で BFF と連携するための管理ユーザーと OIDC クライアントを用意する
return unless Rails.env.development?

User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name = "admin"
  user.password = "password"
  user.admin = true
end

# OIDC クライアントは BFF と同じルート .env の値で登録する
client_id = ENV.fetch("OIDC_CLIENT_ID", "").presence
client_secret = ENV.fetch("OIDC_CLIENT_SECRET", "").presence
redirect_uri = ENV.fetch("OIDC_REDIRECT_URI", "").presence
return if client_id.nil? || client_secret.nil? || redirect_uri.nil?

Doorkeeper::Application.find_or_create_by!(uid: client_id) do |application|
  application.name = "price-monitoring"
  application.secret = client_secret
  application.redirect_uri = redirect_uri
  application.scopes = "openid email profile"
  application.confidential = true
end
