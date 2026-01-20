require "rails_helper"

RSpec.describe OidcTokenControl, type: :request do
  describe "GET /auth/test" do
    let(:oidc_token_endpoint) { "#{ENV.fetch('OIDC_ISSUER', nil)}/oauth/token" }

    context "ログインしていない場合" do
      it "正常にレスポンスを返すこと" do
        get "/auth/test"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Not Logged In")
      end
    end

    context "ログインしている場合" do
      login_with_expiring_token

      context "トークンリフレッシュが成功する場合" do
        before do
          stub_request(:post, oidc_token_endpoint)
            .to_return(
              status: 200,
              body: {
                access_token: "new_access_token",
                refresh_token: "new_refresh_token",
                expires_in: 7200
              }.to_json,
              headers: { "Content-Type" => "application/json" }
            )
        end

        it "正常にレスポンスを返すこと" do
          get "/auth/test"

          expect(response).to have_http_status(:ok)
        end
      end

      context "トークンリフレッシュが失敗する場合" do
        before do
          stub_request(:post, oidc_token_endpoint)
            .to_return(status: 401)
        end

        it "再ログインにリダイレクトすること" do
          get "/auth/test"

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to("/auth/auth_provider")
        end
      end

      context "ネットワークタイムアウトが発生する場合" do
        before do
          stub_request(:post, oidc_token_endpoint)
            .to_timeout
        end

        it "再ログインにリダイレクトすること" do
          get "/auth/test"

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to("/auth/auth_provider")
        end
      end

      context "リトライ後に成功する場合" do
        before do
          stub_request(:post, oidc_token_endpoint)
            .to_timeout.times(2)
            .then.to_return(
              status: 200,
              body: {
                access_token: "new_access_token",
                refresh_token: "new_refresh_token",
                expires_in: 7200
              }.to_json,
              headers: { "Content-Type" => "application/json" }
            )
        end

        it "正常にレスポンスを返すこと" do
          get "/auth/test"

          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
