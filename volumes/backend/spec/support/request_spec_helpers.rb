module RequestSpecHelpers
  # current_userをモックしてログイン状態をシミュレート
  def login_as_user(**options)
    let(:test_user) { create(:user, **options) }

    before do
      allow_any_instance_of(ApplicationController) # rubocop:disable RSpec/AnyInstance
        .to receive(:current_user)
        .and_return(test_user)
    end
  end

  # セッション全体をモックしてログイン状態をシミュレート
  def login_with_session(**options)
    let(:test_user) { create(:user, **options.slice(:email, :name, :provider_uid)) }

    let(:rspec_session) do
      {
        user_id: test_user.id,
        access_token: options.key?(:access_token) ? options[:access_token] : "test_access_token",
        refresh_token: options.key?(:refresh_token) ? options[:refresh_token] : "test_refresh_token",
        expires_at: options.key?(:expires_at) ? options[:expires_at] : 10.minutes.from_now.to_i
      }
    end
  end

  # トークンが期限切れ間近の状態でログイン
  def login_with_expiring_token(**)
    login_with_session(expires_at: 4.minutes.from_now.to_i, **)
  end

  # トークンが期限切れの状態でログイン
  def login_with_expired_token(**)
    login_with_session(expires_at: 1.minute.ago.to_i, **)
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
