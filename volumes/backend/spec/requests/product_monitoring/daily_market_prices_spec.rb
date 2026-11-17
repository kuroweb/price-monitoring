require "rails_helper"

RSpec.describe "商品集計結果", type: :request do
  it "集計設定を横断して日ごとの結果を一覧表示すること" do
    setting = create(:product_monitoring_monitor)
    ProductMonitoring::DailyMarketPrice.create!(monitor: setting, date: Date.new(2026, 11, 2), transaction_count: 0)
    ProductMonitoring::DailyMarketPrice.create!(monitor: setting, date: Date.new(2026, 11, 1), transaction_count: 1)
    get "/api/v1/product_monitoring/daily_market_prices"
    expect(response.parsed_body.fetch("daily_market_prices").pluck("date")).to eq(%w[2026-11-01 2026-11-02])
  end
end
