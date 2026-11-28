require "rails_helper"

RSpec.describe ProductMonitoring::Notification::NewestNotifier do
  include ActiveSupport::Testing::TimeHelpers

  let(:setting) do
    ProductMonitoring::Monitor.create!(name: "phone", newest_notification_enabled: true, required_keywords: ["phone"])
  end
  let(:webhook) { "https://discord.com/api/webhooks/123/token" }
  let(:start) { Time.current.change(usec: 0) }

  before { stub_const("ENV", ENV.to_hash.merge("PRODUCT_MONITORING_DISCORD_WEBHOOK_URL" => webhook)) }

  def save_result(at, **attributes)
    travel_to(at) { create(:product_monitoring_crawl_result, name: "phone", sold: false, **attributes) }
  end

  def evaluate(at)
    travel_to(at) { described_class.call(monitor: setting) }
  end

  it "初回は既存の収集結果を通知せず、その後に保存された新着を新しい順に件数付きで通知する" do
    save_result(start - 1.hour, name: "phone old")
    request = stub_request(:post, webhook).to_return(status: 204)
    evaluate(start)
    expect(request).not_to have_been_requested

    save_result(start + 1.minute, name: "phone first", price: 100)
    save_result(start + 2.minutes, name: "phone second", price: 200)
    evaluate(start + 10.minutes)

    content = "【商品モニタリング】phone 新着2件\nphone second: 200円\nhttps://example.com\nphone first: 100円\n" \
              "https://example.com"
    expect(request.with(body: hash_including("content" => content))).to have_been_requested.once
  end

  it "直近5分に保存された収集結果は次の評価に回し、同じ収集結果を2回通知しない" do
    evaluate(start)
    request = stub_request(:post, webhook).to_return(status: 204)
    save_result(start + 6.minutes)
    evaluate(start + 10.minutes)
    expect(request).not_to have_been_requested

    evaluate(start + 20.minutes)
    evaluate(start + 30.minutes)
    expect(request).to have_been_requested.once
  end

  it "除外・売り切れ・条件外と、範囲より前に保存されたサイト上の同じものを通知しない" do
    save_result(start - 1.hour, platform: "iosys", external_id: "known")
    evaluate(start)
    request = stub_request(:post, webhook).to_return(status: 204)
    save_result(start + 1.minute, excluded_at: start)
    save_result(start + 1.minute, sold: true)
    save_result(start + 1.minute, sold: nil)
    save_result(start + 1.minute, name: "tablet")
    save_result(start + 1.minute, platform: "iosys", external_id: "known",
                                  crawl_setting: create(:product_monitoring_crawl_setting))
    evaluate(start + 10.minutes)

    expect(request).not_to have_been_requested
    expect(setting.reload.newest_notified_until).to eq(start + 5.minutes)
  end

  it "範囲内で複数の収集設定が保存した同じものは1件にまとめる" do
    evaluate(start)
    request = stub_request(:post, webhook).to_return(status: 204)
    save_result(start + 1.minute, platform: "iosys", external_id: "same")
    save_result(start + 2.minutes, platform: "iosys", external_id: "same",
                                   crawl_setting: create(:product_monitoring_crawl_setting))
    evaluate(start + 10.minutes)

    expect(request.with { |req| JSON.parse(req.body).fetch("content").include?("新着1件") }).to have_been_requested.once
  end

  it "送信失敗では基準を更新せず次回まとめて再試行する" do
    evaluate(start)
    save_result(start + 1.minute)
    request = stub_request(:post, webhook).to_return({ status: 500 }, { status: 204 })
    evaluate(start + 10.minutes)
    expect(setting.reload.newest_notified_until).to eq(start - 5.minutes)

    save_result(start + 11.minutes)
    evaluate(start + 20.minutes)
    expect(request.with { |req| JSON.parse(req.body).fetch("content").include?("新着2件") }).to have_been_requested.once
    expect(setting.reload.newest_notified_until).to eq(start + 15.minutes)
  end

  it "Webhook未設定時は基準を進め、設定後に過去の新着を通知しない" do
    evaluate(start)
    request = stub_request(:post, webhook).to_return(status: 204)
    stub_const("ENV", ENV.to_hash.merge("PRODUCT_MONITORING_DISCORD_WEBHOOK_URL" => ""))
    save_result(start + 1.minute)
    evaluate(start + 10.minutes)
    stub_const("ENV", ENV.to_hash.merge("PRODUCT_MONITORING_DISCORD_WEBHOOK_URL" => webhook))
    evaluate(start + 20.minutes)

    expect(request).not_to have_been_requested
  end

  it "新着通知がオフなら評価しない" do
    setting.update!(newest_notification_enabled: false)
    evaluate(start)

    expect(setting.reload.newest_notified_until).to be_nil
  end

  it "除外する出品者の出品は、出品者IDが不明な別の収集設定の同じ出品も含めて新着にしないこと" do
    create(:product_monitoring_excluded_seller, platform: "mercari", seller_id: "Seller_1")
    request = stub_request(:post, webhook).to_return(status: 204)
    evaluate(start)
    save_result(start + 1.minute, name: "phone excluded", platform: "mercari", external_id: "m1", seller_id: "Seller_1")
    save_result(start + 2.minutes, name: "phone excluded", platform: "mercari", external_id: "m1")
    save_result(start + 3.minutes, name: "phone unknown", platform: "mercari", external_id: "m2")
    evaluate(start + 10.minutes)

    expect(request.with { |req| JSON.parse(req.body)["content"].include?("新着1件") }).to have_been_requested.once
    expect(request.with { |req| JSON.parse(req.body)["content"].include?("phone excluded") }).not_to have_been_requested
  end
end
