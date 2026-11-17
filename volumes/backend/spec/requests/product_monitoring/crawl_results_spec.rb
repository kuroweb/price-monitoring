require "rails_helper"

RSpec.describe "商品クロール結果", type: :request do
  it "指定した結果だけを削除し、別の設定の同じ出品を残すこと" do
    result = create(:product_monitoring_crawl_result, external_id: "same")
    other = create(:product_monitoring_crawl_result, external_id: "same")

    delete "/api/v1/product_monitoring/crawl_results/#{result.id}"

    expect(response).to have_http_status(:ok)
    expect(ProductMonitoring::CrawlResult.exists?(result.id)).to be(false)
    expect(ProductMonitoring::CrawlResult.exists?(other.id)).to be(true)
  end

  it "設定ごとに最新の 8 件と全件数を返し詳細は件数を制限しないこと" do
    setting = create(:product_monitoring_crawl_setting)
    other = create(:product_monitoring_crawl_setting)
    results = Array.new(10) { |i| create(:product_monitoring_crawl_result, crawl_setting: setting, sold: i.even?) }
    excluded = create(:product_monitoring_crawl_result, crawl_setting: setting, excluded_at: Time.current)
    other_result = create(:product_monitoring_crawl_result, crawl_setting: other)
    get "/api/v1/product_monitoring/crawl_results"
    expected_ids = [other_result.id] + results.last(8).reverse.map(&:id)
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq(expected_ids)
    expect(response.parsed_body.fetch("counts")).to include(
      { "crawl_setting_id" => setting.id, "sold" => true, "count" => 5 },
      { "crawl_setting_id" => setting.id, "sold" => false, "count" => 5 }
    )
    get "/api/v1/product_monitoring/crawl_results", params: { crawl_setting_id: setting.id }
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq(results.reverse.map(&:id))
    get "/api/v1/product_monitoring/crawl_results", params: { excluded: true }
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq([excluded.id])
  end

  it "クロール設定を横断して結果を一覧表示すること" do
    first = create(:product_monitoring_crawl_result)
    second = create(:product_monitoring_crawl_result)
    get "/api/v1/product_monitoring/crawl_results"
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq([second.id, first.id])

    get "/api/v1/product_monitoring/crawl_results", params: { crawl_setting_id: first.crawl_setting_id }
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq([first.id])
  end
end
