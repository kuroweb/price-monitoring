require "rails_helper"

RSpec.describe ProductMonitoring::Notification::DiscordWebhook do
  let(:webhook) { "https://discord.com/api/webhooks/123/token" }

  before { stub_const("ENV", ENV.to_hash.merge("PRODUCT_MONITORING_DISCORD_WEBHOOK_URL" => webhook)) }

  it "Discord の Webhook だけを送信先として扱う" do
    expect(described_class).to be_configured
    stub_const("ENV", ENV.to_hash.merge("PRODUCT_MONITORING_DISCORD_WEBHOOK_URL" => "https://example.com/api/webhooks/1"))
    expect(described_class).not_to be_configured
    stub_const("ENV", ENV.to_hash.merge("PRODUCT_MONITORING_DISCORD_WEBHOOK_URL" => "http://discord.com/api/webhooks/1"))
    expect(described_class).not_to be_configured
  end

  it "本文を2000文字までに切り詰め、メンションを無効にして送信する" do
    request = stub_request(:post, webhook).with do |req|
      body = JSON.parse(req.body)
      body.fetch("content").length == 2000 && body.fetch("allowed_mentions") == { "parse" => [] }
    end.to_return(status: 204)

    expect(described_class.post("a" * 3000)).to be(true)
    expect(request).to have_been_requested.once
  end

  it "送信に失敗したら false を返す" do
    stub_request(:post, webhook).to_return(status: 500)
    expect(described_class.post("text")).to be(false)
    stub_request(:post, webhook).to_timeout
    expect(described_class.post("text")).to be(false)
  end
end
