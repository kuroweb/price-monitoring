require "rails_helper"

RSpec.describe "ログイン中のユーザー", type: :request do
  context "ログインしている場合" do
    login_with_session(name: "会員", email: "member@example.com")

    it "名前とメールアドレスを返すこと" do
      get "/api/v1/current_user"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq("current_user" => { "name" => "会員", "email" => "member@example.com" })
    end
  end

  context "ログインしていない場合" do
    it "ユーザーを返さないこと" do
      get "/api/v1/current_user"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq("current_user" => nil)
    end
  end
end
