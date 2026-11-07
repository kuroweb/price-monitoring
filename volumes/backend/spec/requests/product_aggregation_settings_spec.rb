require "rails_helper"

RSpec.describe "商品集計設定", type: :request do
  let(:params) do
    { name: "phone", required_keywords: ["phone"], exclude_keywords: ["case"], min_price: nil, max_price: 1_000 }
  end

  it "作成・取得・更新・削除に対応する" do
    post "/api/v1/product_aggregation_settings", params:, as: :json
    expect(response).to have_http_status(:ok)
    id = response.parsed_body.fetch("id")

    put "/api/v1/product_aggregation_settings/#{id}", params: params.merge(name: "updated"), as: :json
    expect(response.parsed_body.fetch("name")).to eq("updated")

    put "/api/v1/product_aggregation_settings/#{id}", params: params.merge(min_price: 2_000), as: :json
    expect(response).to have_http_status(:bad_request)

    delete "/api/v1/product_aggregation_settings/#{id}"
    expect(ProductAggregationSetting.exists?(id)).to be(false)
  end

  it "直近 30 日を集計し日ごとの結果を返す" do
    product_aggregation_setting = create(:product_aggregation_setting, required_keywords: ["phone"])
    create(:product_crawl_result, name: "phone", price: 500, sold: true, bought_date: Time.zone.now)

    post "/api/v1/product_aggregation_settings/#{product_aggregation_setting.id}/calculate"
    expect(response).to have_http_status(:ok)

    get "/api/v1/product_aggregation_results"
    results = response.parsed_body.fetch("product_aggregation_results")
    expect(results.size).to eq(30)
    expect(results.last).to include("date" => Time.zone.today.to_s, "average_purchase_price" => 500,
                                    "purchase_count" => 1)
  end
end

RSpec.describe "商品集計結果", type: :request do
  it "集計設定を横断して日ごとの結果を一覧表示する" do
    setting = create(:product_aggregation_setting)
    ProductAggregationResult.create!(product_aggregation_setting: setting, date: Date.new(2026, 11, 2), purchase_count: 0)
    ProductAggregationResult.create!(product_aggregation_setting: setting, date: Date.new(2026, 11, 1), purchase_count: 1)
    get "/api/v1/product_aggregation_results"
    expect(response.parsed_body.fetch("product_aggregation_results").pluck("date")).to eq(%w[2026-11-01 2026-11-02])
  end
end
