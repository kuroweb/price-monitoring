require "rails_helper"

RSpec.describe "除外する出品者", type: :request do
  let(:path) { "/api/v1/product_monitoring/excluded_sellers" }

  it "サイトと出品者IDを登録・一覧・解除すること" do
    post path, params: { platform: "mercari", seller_id: " Seller_1 " }, as: :json
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to include("platform" => "mercari", "seller_id" => "Seller_1")
    id = response.parsed_body.fetch("id")
    later = create(:product_monitoring_excluded_seller, platform: "yahoo_auction", seller_id: "a")

    # 新しく登録した順に返す
    get path
    expect(response.parsed_body.fetch("excluded_sellers").pluck("id")).to eq([later.id, id])

    delete "#{path}/#{id}"
    expect(response).to have_http_status(:ok)
    expect(ProductMonitoring::ExcludedSeller.pluck(:id)).to eq([later.id])
  end

  it "対象外のサイトと形式の違う出品者IDは理由を付けて 400、同じ組は 409、無い登録の解除は 404 を返すこと" do
    post path, params: { platform: "iosys", seller_id: "a" }, as: :json
    expect(response).to have_http_status(:bad_request)
    expect(response.parsed_body.dig("error", "message")).to eq("サイトの指定が不正です")
    post path, params: { platform: "mercari", seller_id: "has space" }, as: :json
    expect(response).to have_http_status(:bad_request)
    expect(response.parsed_body.dig("error", "message")).to start_with("出品者IDは")

    create(:product_monitoring_excluded_seller, platform: "mercari", seller_id: "Seller_1")
    post path, params: { platform: "mercari", seller_id: "Seller_1" }, as: :json
    expect(response).to have_http_status(:conflict)
    delete "#{path}/0"
    expect(response).to have_http_status(:not_found)
  end

  it "登録すると収集結果の一覧・監視の表示・取引から外し、元の収集結果は消さず、解除すると戻すこと" do
    monitor = create(:product_monitoring_monitor)
    sold_at = Time.current.change(usec: 0)
    results = [
      create(:product_monitoring_crawl_result, platform: "mercari", external_id: "m1", sold: true, sold_at:,
                                               seller_id: "Seller_1"),
      create(:product_monitoring_crawl_result, platform: "mercari", external_id: "m1", sold: true, sold_at:)
    ]
    unknown = create(:product_monitoring_crawl_result, platform: "mercari", external_id: "m2", sold: true, sold_at:)
    shown = lambda do
      get "/api/v1/product_monitoring/crawl_results"
      listed = response.parsed_body.fetch("crawl_results").pluck("id")
      get "/api/v1/product_monitoring/monitors/#{monitor.id}/crawl_results"
      monitored = response.parsed_body.fetch("crawl_results").pluck("id")
      get "/api/v1/product_monitoring/monitors/#{monitor.id}/transactions",
          params: { start_date: Time.zone.today, end_date: Time.zone.today }
      [listed, monitored, response.parsed_body.fetch("transactions").pluck("id")]
    end

    post path, params: { platform: "mercari", seller_id: "Seller_1" }, as: :json
    id = response.parsed_body.fetch("id")
    expect(shown.call).to all(eq([unknown.id]))
    expect(ProductMonitoring::CrawlResult.where(id: results.map(&:id)).count).to eq(2)

    delete "#{path}/#{id}"
    listed, monitored, transactions = shown.call
    expect(listed).to contain_exactly(unknown.id, *results.map(&:id))
    # 監視の表示と取引は同じ出品を1件にまとめる
    external_ids = ->(ids) { ProductMonitoring::CrawlResult.where(id: ids).map(&:external_id) }
    expect(external_ids.call(monitored)).to contain_exactly("m1", "m2")
    expect(external_ids.call(transactions)).to contain_exactly("m1", "m2")
  end
end
