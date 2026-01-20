require "rails_helper"

RSpec.describe SessionsController, type: :request do
  describe "DELETE /logout" do
    let(:user_info) do
      {
        email: "test@example.com",
        name: "Test User",
        provider: "auth_provider",
        uid: "user_123"
      }
    end

    context "有効なトークンでログインしている場合" do
      before do
        get "/auth/test"
        session = request.session
        session[:user_id] = "user_123"
        session[:user_info] = user_info
        session[:access_token] = "test_access_token"
        session[:refresh_token] = "test_refresh_token"
        session[:expires_at] = 1.hour.from_now.to_i
      end

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

      it "成功メッセージとともに /auth/test にリダイレクトすること" do
        stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")
          .to_return(status: 200)

        delete "/logout"

        expect(response).to redirect_to("/auth/test")
        expect(flash[:notice]).to eq("Logged out successfully")
      end
    end

    context "トークン失効が失敗した場合" do
      before do
        get "/auth/test"
        session = request.session
        session[:user_id] = "user_123"
        session[:user_info] = user_info
        session[:access_token] = "test_access_token"
        session[:refresh_token] = "test_refresh_token"
        session[:expires_at] = 1.hour.from_now.to_i
      end

      it "失効に失敗してもセッションを削除すること" do
        stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")
          .to_return(status: 500, body: "Internal Server Error")

        delete "/logout"

        expect(response).to redirect_to("/auth/test")
        expect(flash[:notice]).to eq("Logged out successfully")
      end

      it "ネットワークエラーが発生してもログアウトできること" do
        stub_request(:post, "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/revoke")
          .to_raise(Faraday::ConnectionFailed.new("Connection failed"))

        delete "/logout"

        expect(response).to redirect_to("/auth/test")
        expect(flash[:notice]).to eq("Logged out successfully")
      end
    end

    context "リフレッシュトークンなしでログインしている場合" do
      before do
        get "/auth/test"
        session = request.session
        session[:user_id] = "user_123"
        session[:user_info] = user_info
        session[:access_token] = "test_access_token"
        session[:expires_at] = 1.hour.from_now.to_i
      end

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
        expect(response).to redirect_to("/auth/test")
      end
    end
  end

  describe "GET /auth/failure" do
    it "エラーメッセージとともに /auth/test にリダイレクトすること" do
      get "/auth/failure", params: { message: "invalid_credentials" }

      expect(response).to redirect_to("/auth/test")
      expect(flash[:alert]).to eq("Authentication failed: invalid_credentials")
    end

    it "エラーメッセージがない場合はデフォルトメッセージを表示すること" do
      get "/auth/failure"

      expect(response).to redirect_to("/auth/test")
      expect(flash[:alert]).to eq("Authentication failed: Unknown error")
    end

    it "認証失敗をログに記録すること" do
      expect(Rails.logger).to receive(:error).with("Authentication failed: test_error")

      get "/auth/failure", params: { message: "test_error" }
    end
  end
end
