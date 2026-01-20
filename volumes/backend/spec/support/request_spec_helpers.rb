module RequestSpecHelpers
  # ログイン状態をシミュレート
  def login_as(user_id: "user_123", expires_at: 10.minutes.from_now.to_i, **options)
    let(:rspec_session) do
      {
        user_id: user_id,
        user_info: options[:user_info] || { email: "test@example.com", name: "Test User" },
        access_token: options[:access_token] || "test_access_token",
        refresh_token: options[:refresh_token] || "test_refresh_token",
        expires_at: expires_at
      }
    end
  end

  # トークンが期限切れ間近の状態でログイン
  def login_with_expiring_token(user_id: "user_123", **)
    login_as(user_id: user_id, expires_at: 4.minutes.from_now.to_i, **)
  end

  # トークンが期限切れの状態でログイン
  def login_with_expired_token(user_id: "user_123", **)
    login_as(user_id: user_id, expires_at: 1.minute.ago.to_i, **)
  end
end

RSpec.configure do |config|
  config.extend RequestSpecHelpers, type: :request

  config.before(:each, type: :request) do
    ENV["OIDC_ISSUER"] = "https://test-oidc.example.com"
    ENV["OIDC_CLIENT_ID"] = "test_client_id"
    ENV["OIDC_CLIENT_SECRET"] = "test_client_secret"
  end
end
