require "rails_helper"

RSpec.describe "商品集計設定", type: :request do
  it "直近 30 日を集計し日ごとの結果を返すこと" do
    product_watch_setting = create(:product_watch_setting, required_keywords: ["phone"])
    create(:product_crawl_result, name: "phone", price: 500, sold: true, bought_date: Time.zone.now)

    post "/api/v1/product_watch_settings/#{product_watch_setting.id}/calculate"
    expect(response).to have_http_status(:ok)

    get "/api/v1/product_aggregation_results"
    results = response.parsed_body.fetch("product_aggregation_results")
    expect(results.size).to eq(30)
    expect(results.last).to include("date" => Time.zone.today.to_s, "average_purchase_price" => 500,
                                    "purchase_count" => 1)
  end

  it "期間内の集計対象になる購入を売れた日の新しい順に返すこと" do
    product_watch_setting = create(:product_watch_setting, required_keywords: ["phone"])
    date = Date.new(2026, 11, 1)
    create(:product_crawl_result, external_id: "old", name: "phone", sold: true, bought_date: date.in_time_zone.change(hour: 12))
    create(:product_crawl_result, external_id: "new", name: "phone", sold: true, bought_date: (date + 1).in_time_zone)
    create(:product_crawl_result, external_id: "other", name: "tablet", sold: true, bought_date: date.in_time_zone)
    create(:product_crawl_result, external_id: "outside", name: "phone", sold: true, bought_date: (date - 1).in_time_zone)

    get "/api/v1/product_watch_settings/#{product_watch_setting.id}/purchases",
        params: { start_date: date.to_s, end_date: (date + 1).to_s }
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.fetch("product_crawl_results").pluck("external_id")).to eq(%w[new old])
  end

  it "期間の日付が不正なとき 400 を返すこと" do
    product_watch_setting = create(:product_watch_setting)
    get "/api/v1/product_watch_settings/#{product_watch_setting.id}/purchases",
        params: { start_date: "invalid", end_date: "2026-11-01" }
    expect(response).to have_http_status(:bad_request)
  end

  it "購入商品の期間は90日以内で開始日以前に終了しないこと" do
    setting = create(:product_watch_setting)
    url = "/api/v1/product_watch_settings/#{setting.id}/purchases"
    get url, params: { start_date: "2026-01-01", end_date: "2026-03-31" }
    expect(response).to have_http_status(:ok)
    get url, params: { start_date: "2026-01-01", end_date: "2026-04-01" }
    expect(response).to have_http_status(:bad_request)
    get url, params: { start_date: "2026-01-02", end_date: "2026-01-01" }
    expect(response).to have_http_status(:bad_request)
  end
end

RSpec.describe "商品集計結果", type: :request do
  it "集計設定を横断して日ごとの結果を一覧表示すること" do
    setting = create(:product_watch_setting)
    ProductAggregationResult.create!(product_watch_setting: setting, date: Date.new(2026, 11, 2), purchase_count: 0)
    ProductAggregationResult.create!(product_watch_setting: setting, date: Date.new(2026, 11, 1), purchase_count: 1)
    get "/api/v1/product_aggregation_results"
    expect(response.parsed_body.fetch("product_aggregation_results").pluck("date")).to eq(%w[2026-11-01 2026-11-02])
  end
end
