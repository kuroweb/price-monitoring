require "rails_helper"

RSpec.describe SessionsController, type: :request do
  describe "GET /auth/auth_provider/callback のリクエスト" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        uid: "provider-user-1",
        info: { name: "会員", email: "member@example.com" },
        credentials: { token: "access-token", refresh_token: "refresh-token", expires_in: 7200 }
      )
    end

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:auth_provider] = auth
    end

    after do
      OmniAuth.config.mock_auth.delete(:auth_provider)
      OmniAuth.config.test_mode = false
    end

    it "ユーザーを登録し、アプリのトップ画面に戻すこと" do
      expect do
        get "/auth/auth_provider/callback"
      end.to change(User, :count).by(1)

      expect(User.find_by!(provider_uid: "provider-user-1")).to have_attributes(
        name: "会員", email: "member@example.com", provider_name: User::ProviderName::AUTH_PROVIDER
      )
      expect(response).to redirect_to("/")
    end
  end

  describe "DELETE /logout のリクエスト" do
    context "有効なトークンでログインしている場合" do
      login_with_session

      it "アクセストークンとリフレッシュトークンを失効させること" do
        stub_revoke = stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")
                      .with(
                        body: hash_including(
                          "token" => "test_access_token",
                          "token_type_hint" => "access_token"
                        )
                      ).to_return(status: 200)

        stub_revoke_refresh = stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")
                              .with(
                                body: hash_including(
                                  "token" => "test_refresh_token",
                                  "token_type_hint" => "refresh_token"
                                )
                              ).to_return(status: 200)

        delete "/logout"

        expect(stub_revoke).to have_been_requested.once
        expect(stub_revoke_refresh).to have_been_requested.once
      end

      it "アプリのトップ画面にリダイレクトすること" do
        stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")
          .to_return(status: 200)

        delete "/logout"

        expect(response).to redirect_to("/")
        expect(response).to have_http_status(:see_other)
      end
    end

    context "トークン失効が失敗した場合" do
      login_with_session

      it "失効に失敗してもセッションを削除すること" do
        stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")
          .to_return(status: 500, body: "Internal Server Error")

        delete "/logout"

        expect(response).to redirect_to("/")
      end

      it "ネットワークエラーが発生してもログアウトできること" do
        allow(Bugsnag).to receive(:notify)
        stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")
          .to_raise(Faraday::ConnectionFailed.new("Connection failed"))

        delete "/logout"

        expect(response).to redirect_to("/")
        expect(Bugsnag).to have_received(:notify).with(an_instance_of(Faraday::ConnectionFailed))
      end
    end

    context "リフレッシュトークンなしでログインしている場合" do
      login_with_session(refresh_token: nil)

      it "アクセストークンのみを失効させること" do
        stub_revoke = stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")
                      .with(
                        body: hash_including(
                          "token" => "test_access_token",
                          "token_type_hint" => "access_token"
                        )
                      ).to_return(status: 200)

        delete "/logout"

        expect(stub_revoke).to have_been_requested.once
      end
    end

    context "ログインしていない場合" do
      it "トークン失効を試みないこと" do
        stub_revoke = stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")

        delete "/logout"

        expect(stub_revoke).not_to have_been_requested
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "ログアウトの CSRF 検証" do
    around do |example|
      previous = ActionController::Base.allow_forgery_protection
      ActionController::Base.allow_forgery_protection = true
      example.run
    ensure
      ActionController::Base.allow_forgery_protection = previous
    end

    it "トークンがないリクエストを拒否すること" do
      delete "/logout"
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "同じセッションのトークンでログアウトできること" do
      get "/auth/csrf_token"
      token = response.parsed_body.fetch("csrf_token")
      expect(response.headers["Cache-Control"]).to include("no-store")
      delete "/logout", headers: { "X-CSRF-Token" => token }
      expect(response).to redirect_to("/")
    end

    it "別のセッションのトークンを拒否すること" do
      get "/auth/csrf_token"
      token = response.parsed_body.fetch("csrf_token")
      request.session.clear
      other_session = open_session
      other_session.delete "/logout", headers: { "X-CSRF-Token" => token }
      expect(other_session.response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /auth/failure のリクエスト" do
    it "認証失敗を示してアプリのトップ画面にリダイレクトすること" do
      get "/auth/failure", params: { message: "invalid_credentials" }

      expect(response).to redirect_to("/products?auth_error=1")
    end

    it "エラーメッセージがない場合も認証失敗を示すこと" do
      get "/auth/failure"

      expect(response).to redirect_to("/products?auth_error=1")
    end

    it "認証失敗をログに記録すること" do
      allow(Rails.logger).to receive(:error)

      get "/auth/failure", params: { message: "test_error" }

      expect(Rails.logger).to have_received(:error).with("Authentication failed: test_error")
    end
  end
end
