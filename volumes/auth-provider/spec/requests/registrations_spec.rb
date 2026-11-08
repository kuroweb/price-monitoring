require "rails_helper"

RSpec.describe "会員登録", type: :request do
  let(:attributes) do
    { name: "新規会員", email: "member@example.com", password: "password123", password_confirmation: "password123" }
  end

  it "登録画面に必要な入力欄を表示すること" do
    get new_user_registration_path

    expect(response).to have_http_status(:success)
    expect(response.body).to include(
      'name="user[name]"', 'name="user[email]"', 'name="user[password]"', 'name="user[password_confirmation]"'
    )
  end

  it "管理者権限を指定しても一般ユーザーとして登録すること" do
    expect do
      post user_registration_path, params: { user: attributes.merge(admin: true) }
    end.to change(User, :count).by(1)

    expect(User.find_by!(email: attributes[:email])).not_to be_admin
  end

  it "入力に誤りがある場合は登録せずエラーを表示すること" do
    expect do
      post user_registration_path, params: { user: attributes.merge(password_confirmation: "different") }
    end.not_to change(User, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include('id="error_explanation"')
    expect(response.body).to include("パスワード（確認）が一致しません")
  end

  it "登録済みのメールアドレスでは登録できないこと" do
    create(:user, email: attributes[:email])

    expect do
      post user_registration_path, params: { user: attributes }
    end.not_to change(User, :count)

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "認可途中で登録すると元の認可要求に戻ること" do
    client = Doorkeeper::Application.create!(
      name: "Client", redirect_uri: "https://client.example.com/callback", scopes: "openid email profile"
    )
    authorization = {
      client_id: client.uid, redirect_uri: client.redirect_uri, response_type: "code",
      scope: "openid email profile", state: "test-state"
    }

    get oauth_authorization_path, params: authorization
    expect(response).to redirect_to(new_user_session_url)

    get new_user_registration_path
    post user_registration_path, params: { user: attributes.merge(password_confirmation: "different") }
    expect(response).to have_http_status(:unprocessable_content)
    post user_registration_path, params: { user: attributes }

    expect(response).to redirect_to(%r{/oauth/authorize\?})
    follow_redirect!
    callback = URI.parse(response.location)
    expect("#{callback.scheme}://#{callback.host}#{callback.path}").to eq(client.redirect_uri)
    expect(Rack::Utils.parse_query(callback.query)).to include("state" => "test-state", "code" => be_present)
  end
end
