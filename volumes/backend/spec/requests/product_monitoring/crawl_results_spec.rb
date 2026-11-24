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

  it "設定を横断して抽出条件に一致する保存済みの出品だけをページ単位で返すこと" do
    path = "/api/v1/product_monitoring/crawl_results/search"
    filters = { required_keywords: %w[iPad Pro], negative_keywords: ["ケース"],
                min_price: 100, max_price: 120, sort: "price_asc" }
    results = (100..112).map do |price|
      create(:product_monitoring_crawl_result, name: "ｉＰａｄ Ｐｒｏ", price:, sold: price.even?)
    end
    create(:product_monitoring_crawl_result, name: "iPad Pro", price: 120,
                                             platform: results.first.platform, external_id: results.first.external_id)
    create(:product_monitoring_crawl_result, name: "iPad Pro", price: 99)
    create(:product_monitoring_crawl_result, name: "iPad Pro", price: 121)
    create(:product_monitoring_crawl_result, name: "iPad", price: 100)
    create(:product_monitoring_crawl_result, name: "iPad Pro ケース", price: 100)
    create(:product_monitoring_crawl_result, name: "iPad Pro", price: 100, excluded_at: Time.current)

    expect do
      post path, params: filters, as: :json
    end.not_to change(ProductMonitoring::Monitor, :count)
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to include("page" => 1, "per_page" => 12, "has_more" => true)
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq(results.first(12).map(&:id))

    post path, params: filters.merge(page: 2), as: :json

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to include("page" => 2, "has_more" => false)
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq([results.last.id])
  end

  it "販売状態で売り切れ、販売中、すべてを分けること" do
    path = "/api/v1/product_monitoring/crawl_results/search"
    on_sale = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: false)
    unknown = create(:product_monitoring_crawl_result, name: "phone", price: 150, sold: nil)
    sold = create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: true)
    create(:product_monitoring_crawl_result, name: "phone", price: 50, sold: true, excluded_at: Time.current)
    filters = { required_keywords: ["phone"], sort: "price_asc" }

    post path, params: filters.merge(sale_status: "sold", page: 1), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to include("page" => 1, "per_page" => 12, "has_more" => false)
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq([sold.id])

    post path, params: filters.merge(sale_status: "on_sale", page: 1), as: :json
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq([on_sale.id, unknown.id])

    post path, params: filters.merge(sale_status: "all", page: 1), as: :json
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq([on_sale.id, unknown.id, sold.id])
  end

  it "抽出条件の値やページ指定が不正なら検索せず400を返すこと" do
    path = "/api/v1/product_monitoring/crawl_results/search"
    [
      { required_keywords: "phone" }, { negative_keywords: ["x" * 256] },
      { min_price: -1 }, { min_price: 2, max_price: 1 }, { page: 0 }, { sort: "unknown" },
      { sale_status: "other" }
    ].each do |filters|
      post path, params: filters, as: :json
      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body.fetch("error").fetch("message")).to be_present
    end
  end

  it "検索処理の想定外の例外はサーバーエラーとして扱い、詳細を返さないこと" do
    allow(ProductMonitoring::Search::MatchingCrawlResults).to receive(:call).and_raise(ArgumentError, "internal detail")

    post "/api/v1/product_monitoring/crawl_results/search", params: {}, as: :json

    expect(response).to have_http_status(:service_unavailable)
    expect(response.parsed_body.fetch("error").fetch("message")).to eq("Internal Server Error.")
  end
end
