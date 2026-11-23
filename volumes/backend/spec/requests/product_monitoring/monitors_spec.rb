require "rails_helper"

RSpec.describe "モニタリング設定", type: :request do
  let(:settings) do
    { name: "phone", enabled: true, discord_enabled: true, required_keywords: ["phone"],
      negative_keywords: ["case"], min_price: nil, max_price: 1_000 }
  end

  it "設定を登録・取得・更新・削除する" do
    post "/api/v1/product_monitoring/monitors", params: settings, as: :json
    expect(response).to have_http_status(:ok)
    id = response.parsed_body.fetch("id")
    get "/api/v1/product_monitoring/monitors"
    expect(response.parsed_body.fetch("monitors").pluck("id")).to include(id)
    expect(response.parsed_body).to have_key("discord_configured")
    put "/api/v1/product_monitoring/monitors/#{id}", params: settings.merge(min_price: 2_000), as: :json
    expect(response).to have_http_status(:bad_request)
    put "/api/v1/product_monitoring/monitors/#{id}", params: settings.merge(name: "updated"), as: :json
    expect(response.parsed_body.fetch("name")).to eq("updated")
    delete "/api/v1/product_monitoring/monitors/#{id}"
    expect(ProductMonitoring::Monitor.exists?(id)).to be(false)
  end

  it "全計測から条件に一致する商品を売り切れも含めて新着順に重複なく返す" do
    setting = ProductMonitoring::Monitor.create!(settings)
    create(:product_monitoring_crawl_result, name: "phone", price: 500, sold: false, platform: "iosys",
                                             external_id: "one")
    create(:product_monitoring_crawl_result, name: "phone", price: 500, sold: false, platform: "iosys",
                                             external_id: "one")
    create(:product_monitoring_crawl_result, name: "phone", price: 500, sold: false, platform: "mercari",
                                             external_id: "two")
    create(:product_monitoring_crawl_result, name: "phone case", price: 1, sold: false)
    create(:product_monitoring_crawl_result, name: "phone", price: 1, sold: true, sold_at: Time.current,
                                             external_id: "sold")
    create(:product_monitoring_crawl_result, name: "phone", price: 1, sold: false, excluded_at: Time.current)
    get "/api/v1/product_monitoring/monitors/#{setting.id}/crawl_results"
    expect(response.parsed_body.fetch("crawl_results").pluck("external_id")).to eq(%w[sold two one])
  end

  it "条件の変更時だけ古い相場を消し、設定削除時にも相場を削除する" do
    setting = ProductMonitoring::Monitor.create!(settings)
    setting.daily_market_prices.create!(date: Date.current, transaction_count: 1)
    put "/api/v1/product_monitoring/monitors/#{setting.id}", params: settings.merge(name: "updated"), as: :json
    expect(setting.daily_market_prices.count).to eq(1)
    put "/api/v1/product_monitoring/monitors/#{setting.id}", params: settings.merge(max_price: 500), as: :json
    expect(setting.daily_market_prices.count).to eq(0)
    setting.daily_market_prices.create!(date: Date.current, transaction_count: 1)
    delete "/api/v1/product_monitoring/monitors/#{setting.id}"
    expect(ProductMonitoring::DailyMarketPrice.count).to eq(0)
  end

  it "新着通知の指定を保存し、条件か新着通知の指定を変えたときだけ新着通知の基準を取り直す" do
    post "/api/v1/product_monitoring/monitors", params: settings.merge(newest_notification_enabled: true), as: :json
    expect(response.parsed_body).to include("newest_notification_enabled" => true)
    expect(response.parsed_body).not_to have_key("newest_notified_until")
    setting = ProductMonitoring::Monitor.find(response.parsed_body.fetch("id"))
    url = "/api/v1/product_monitoring/monitors/#{setting.id}"
    base = settings.merge(newest_notification_enabled: true)

    setting.update!(newest_notified_until: Time.current)
    put url, params: base.merge(name: "updated"), as: :json
    expect(setting.reload.newest_notified_until).not_to be_nil
    put url, params: base.merge(max_price: 500), as: :json
    expect(setting.reload.newest_notified_until).to be_nil

    setting.update!(newest_notified_until: Time.current)
    put url, params: base.merge(max_price: 500, newest_notification_enabled: false), as: :json
    expect(setting.reload).to have_attributes(newest_notification_enabled: false, newest_notified_until: nil)
  end

  it "条件に一致する商品を重複を除いて新着順に最大8件返す" do
    setting = ProductMonitoring::Monitor.create!(settings)
    create(:product_monitoring_crawl_result, name: "phone", price: 10, sold: false, external_id: "item-0")
    expected = (1..8).map do |price|
      create(:product_monitoring_crawl_result, name: "phone", price: price * 10, sold: price.even?,
                                               sold_at: (Time.current if price.even?), external_id: "item-#{price}")
    end
    create(:product_monitoring_crawl_result, name: "phone case", price: 1, sold: false)

    get "/api/v1/product_monitoring/monitors/#{setting.id}/crawl_results"

    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq(expected.reverse.map(&:id))
  end

  describe "最安値と直近の平均取引価格" do
    it "収集結果の8件の外も含めた販売中の最安値と、平均取引価格のある最新の日の値を返すこと" do
      setting = ProductMonitoring::Monitor.create!(settings)
      create(:product_monitoring_crawl_result, name: "phone", price: 300, sold: false)
      9.times { create(:product_monitoring_crawl_result, name: "phone", price: 900, sold: false) }
      create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: true)
      create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: false, excluded_at: Time.current)
      create(:product_monitoring_crawl_result, name: "phone case", price: 100, sold: false)
      setting.daily_market_prices.create!(date: Date.current - 2, average_transaction_price: 700,
                                          transaction_count: 1)
      setting.daily_market_prices.create!(date: Date.current - 1, average_transaction_price: 800,
                                          transaction_count: 1)
      setting.daily_market_prices.create!(date: Date.current, transaction_count: 0)

      get "/api/v1/product_monitoring/monitors/#{setting.id}/summary"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq("lowest_price" => 300, "latest_average_transaction_price" => 800)
    end

    it "該当がなければ null を返すこと" do
      setting = ProductMonitoring::Monitor.create!(settings)
      create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: true)
      setting.daily_market_prices.create!(date: Date.current, transaction_count: 0)

      get "/api/v1/product_monitoring/monitors/#{setting.id}/summary"

      expect(response.parsed_body).to eq("lowest_price" => nil, "latest_average_transaction_price" => nil)
    end

    it "存在しないモニタリング設定は 404 を返すこと" do
      get "/api/v1/product_monitoring/monitors/0/summary"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "日次相場の集計" do
    it "直近 30 日を集計し日ごとの結果を返すこと" do
      monitor = create(:product_monitoring_monitor, required_keywords: ["phone"])
      create(:product_monitoring_crawl_result, name: "phone", price: 500, sold: true, sold_at: Time.zone.now)

      post "/api/v1/product_monitoring/monitors/#{monitor.id}/aggregate_daily_market_prices"
      expect(response).to have_http_status(:ok)

      get "/api/v1/product_monitoring/daily_market_prices"
      results = response.parsed_body.fetch("daily_market_prices")
      expect(results.size).to eq(30)
      expect(results.last).to include("date" => Time.zone.today.to_s, "average_transaction_price" => 500,
                                      "transaction_count" => 1)
    end

    it "期間内の集計対象になる取引を売れた日の新しい順に返すこと" do
      monitor = create(:product_monitoring_monitor, required_keywords: ["phone"])
      date = Date.new(2026, 11, 1)
      create(:product_monitoring_crawl_result, external_id: "old", name: "phone", sold: true,
                                               sold_at: date.in_time_zone.change(hour: 12))
      create(:product_monitoring_crawl_result, external_id: "new", name: "phone", sold: true,
                                               sold_at: (date + 1).in_time_zone)
      create(:product_monitoring_crawl_result, external_id: "other", name: "tablet", sold: true,
                                               sold_at: date.in_time_zone)
      create(:product_monitoring_crawl_result, external_id: "outside", name: "phone", sold: true,
                                               sold_at: (date - 1).in_time_zone)

      get "/api/v1/product_monitoring/monitors/#{monitor.id}/transactions",
          params: { start_date: date.to_s, end_date: (date + 1).to_s }
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.fetch("transactions").pluck("external_id")).to eq(%w[new old])
    end

    it "期間の日付が不正なとき 400 を返すこと" do
      monitor = create(:product_monitoring_monitor)
      get "/api/v1/product_monitoring/monitors/#{monitor.id}/transactions",
          params: { start_date: "invalid", end_date: "2026-11-01" }
      expect(response).to have_http_status(:bad_request)
    end

    it "取引の期間は90日以内で開始日以前に終了しないこと" do
      setting = create(:product_monitoring_monitor)
      url = "/api/v1/product_monitoring/monitors/#{setting.id}/transactions"
      get url, params: { start_date: "2026-01-01", end_date: "2026-03-31" }
      expect(response).to have_http_status(:ok)
      get url, params: { start_date: "2026-01-01", end_date: "2026-04-01" }
      expect(response).to have_http_status(:bad_request)
      get url, params: { start_date: "2026-01-02", end_date: "2026-01-01" }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
