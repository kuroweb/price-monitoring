require "rails_helper"

RSpec.describe "ログアウト（RP-Initiated Logout）", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user) }
  let(:client) do
    Doorkeeper::Application.create!(
      name: "Client", redirect_uri: "https://client.example.com/auth/callback", scopes: "openid email profile"
    )
  end
  let(:id_token) do
    access_token = Doorkeeper::AccessToken.create!(application: client, resource_owner_id: user.id, scopes: "openid")
    Doorkeeper::OpenidConnect::IdToken.new(access_token).as_jws_token
  end

  before do
    sign_in user
  end

  def signed_in?
    get root_path
    response.successful?
  end

  it "ID トークンのクライアントと同じオリジンの戻り先へ、Provider のセッションを終了して戻すこと" do
    get end_session_path, params: { id_token_hint: id_token, post_logout_redirect_uri: "https://client.example.com/" }

    expect(response).to redirect_to("https://client.example.com/")
    expect(signed_in?).to be(false)
  end

  it "有効期限が切れた ID トークンでもログアウトできること" do
    token = id_token
    travel 1.day

    get end_session_path, params: { id_token_hint: token, post_logout_redirect_uri: "https://client.example.com/" }

    expect(response).to redirect_to("https://client.example.com/")
    expect(signed_in?).to be(false)
  end

  it "クライアントと異なるオリジンの戻り先には戻さず、ログイン画面へ移すこと" do
    get end_session_path, params: { id_token_hint: id_token, post_logout_redirect_uri: "https://evil.example.com/" }

    expect(response).to redirect_to(new_user_session_path)
    expect(signed_in?).to be(false)
  end

  it "正しくない ID トークンではセッションを終了しないこと" do
    get end_session_path, params: { id_token_hint: "invalid", post_logout_redirect_uri: "https://client.example.com/" }

    expect(response).to redirect_to(root_path)
    expect(signed_in?).to be(true)
  end

  it "discovery でログアウトのエンドポイントを公開すること" do
    get "/.well-known/openid-configuration"

    expect(response.parsed_body["end_session_endpoint"]).to eq(end_session_url)
  end
end
