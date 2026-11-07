require "rails_helper"

RSpec.describe "開発環境のseed" do
  let(:seed_path) { Rails.root.join("db/seeds.rb") }

  before do
    allow(Rails.env).to receive(:development?).and_return(true)
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("OIDC_CLIENT_ID", "").and_return("seed-test-client")
    allow(ENV).to receive(:fetch).with("OIDC_CLIENT_SECRET", "").and_return("seed-test-secret")
    allow(ENV).to receive(:fetch).with("OIDC_REDIRECT_URI", "").and_return("https://example.com/callback")
  end

  it "2回実行してもクライアントと管理者を重複させずに登録する" do
    load seed_path
    load seed_path

    client = Doorkeeper::Application.find_by!(uid: "seed-test-client")
    expect(client.secret).to eq("seed-test-secret")
    expect(client.redirect_uri).to eq("https://example.com/callback")
    expect(client.scopes.to_s).to eq("openid email profile")
    expect(client).to be_confidential
    expect(Doorkeeper::Application.where(uid: "seed-test-client").count).to eq(1)
    expect(User.find_by!(email: "admin@example.com")).to be_admin
  end

  %w[OIDC_CLIENT_ID OIDC_CLIENT_SECRET OIDC_REDIRECT_URI].each do |key|
    [nil, "", " "].each do |value|
      it "#{key}が#{value.inspect}の場合は明示的にエラーを出す" do
        allow(ENV).to receive(:fetch).with(key, "").and_return(value)

        expect { load seed_path }.to raise_error(ArgumentError, "#{key} is required")
        expect(Doorkeeper::Application.where(uid: "seed-test-client")).not_to exist
      end
    end
  end

  it "開発環境以外ではクライアントを初期化しない" do
    allow(Rails.env).to receive(:development?).and_return(false)

    expect { load seed_path }.not_to change(Doorkeeper::Application, :count)
  end
end
