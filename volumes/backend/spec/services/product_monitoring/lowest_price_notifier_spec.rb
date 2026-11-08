require "rails_helper"

RSpec.describe ProductMonitoring::LowestPriceNotifier do
  let(:setting) { ProductWatchSetting.create!(name: "phone", enabled: true, discord_enabled: true) }
  let(:webhook) { "https://discord.com/api/webhooks/123/token" }

  before { stub_const("ENV", ENV.to_hash.merge("PRODUCT_MONITORING_DISCORD_WEBHOOK_URL" => webhook)) }

  it "初回は通知せず、変化時に通知し、同じ最安を再通知しない" do
    result = create(:product_crawl_result, sold: false, price: 100)
    request = stub_request(:post, webhook).to_return(status: 204)
    described_class.call(product_watch_setting: setting)
    expect(request).not_to have_been_requested
    result.update!(price: 90)
    described_class.call(product_watch_setting: setting)
    described_class.call(product_watch_setting: setting)
    expect(request).to have_been_requested.once
  end

  it "過去の通知設定が無効でも、有効なモニタリングは通知する" do
    setting.update!(discord_enabled: false)
    result = create(:product_crawl_result, sold: false, price: 100)
    request = stub_request(:post, webhook).to_return(status: 204)
    described_class.call(product_watch_setting: setting)
    result.update!(price: 90)
    described_class.call(product_watch_setting: setting)
    expect(request).to have_been_requested.once
  end

  it "送信失敗では基準を更新せず次回再試行する" do
    result = create(:product_crawl_result, sold: false, price: 100)
    described_class.call(product_watch_setting: setting)
    old_signature = setting.reload.last_lowest_signature
    result.update!(price: 90)
    request = stub_request(:post, webhook).to_return({ status: 500 }, { status: 204 })
    described_class.call(product_watch_setting: setting)
    expect(setting.reload.last_lowest_signature).to eq(old_signature)
    described_class.call(product_watch_setting: setting)
    expect(request).to have_been_requested.twice
    expect(setting.reload.last_lowest_signature).not_to eq(old_signature)
  end

  it "最安消失時は通知せず、再出現時に通知する" do
    result = create(:product_crawl_result, sold: false)
    request = stub_request(:post, webhook).to_return(status: 204)
    described_class.call(product_watch_setting: setting)
    result.update!(sold: true)
    described_class.call(product_watch_setting: setting)
    expect(request).not_to have_been_requested
    result.update!(sold: false)
    described_class.call(product_watch_setting: setting)
    expect(request).to have_been_requested.once
  end
end
