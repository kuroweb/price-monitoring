require "rails_helper"

RSpec.describe "認可", type: :request do
  describe "GET /oauth/authorize" do
    before do
      sign_in create(:user)
    end

    it "未登録のクライアントでは日本語のエラー画面を表示すること" do
      get oauth_authorization_path, params: {
        client_id: "unknown-client", redirect_uri: "https://client.example.com/callback", response_type: "code",
        scope: "openid"
      }

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include("エラーが発生しました", "クライアントの認証に失敗しました")
      expect(response.body).not_to include("Translation missing", "translation_missing")
    end
  end
end
