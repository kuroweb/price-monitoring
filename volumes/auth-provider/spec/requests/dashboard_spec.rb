require "rails_helper"

RSpec.describe "ダッシュボード", type: :request do
  describe "GET /" do
    context "ユーザーが認証されていないとき" do
      it "ログインページにリダイレクトすること" do
        get root_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ユーザーが認証されているとき" do
      let(:user) { create(:user, name: "Test User", email: "test@example.com") }

      before do
        sign_in user
      end

      it "成功レスポンスを返すこと" do
        get root_path

        expect(response).to have_http_status(:success)
      end

      it "ユーザー名を表示すること" do
        get root_path

        expect(response.body).to include("Test User")
      end

      it "メールアドレスを表示すること" do
        get root_path

        expect(response.body).to include("test@example.com")
      end

      it "プロフィール編集リンクを表示すること" do
        get root_path

        expect(response.body).to include("プロフィール編集")
      end

      it "ログアウトボタンを表示すること" do
        get root_path

        expect(response.body).to include("ログアウト")
      end

      it "連携アプリケーションがない場合はその旨を表示すること" do
        get root_path

        expect(response.body).to include("連携しているアプリケーションはありません")
      end
    end

    context "ユーザーに連携済みのOAuthアプリケーションがあるとき" do
      let(:user) { create(:user) }
      let(:oauth_application) { Doorkeeper::Application.create!(name: "Test App", redirect_uri: "https://example.com/callback", scopes: "openid") }

      before do
        sign_in user
        Doorkeeper::AccessToken.create!(
          application: oauth_application,
          resource_owner_id: user.id,
          scopes: "openid",
          expires_in: 7200
        )
      end

      it "連携アプリケーション名を表示すること" do
        get root_path

        expect(response.body).to include("Test App")
      end
    end
  end
end
