require "rails_helper"

RSpec.describe "Product crawl settings", type: :request do
  let(:params) do
    {
      name: "phone", enabled: true, min_price: 100,
      search_urls: ["https://jp.mercari.com/search?keyword=phone", "https://iosys.co.jp/items?q=phone"],
      required_keywords: ["phone"], exclude_keywords: []
    }
  end

  it "supports CRUD with search URLs and filters in one row" do
    expect { post "/api/v1/product_crawl_settings", params:, as: :json }.to change(ProductCrawlSetting, :count).by(1)
    expect(response).to have_http_status(:ok)
    id = response.parsed_body.fetch("id")
    expect(ProductCrawlSetting.find(id).search_urls.size).to eq(2)

    get "/api/v1/product_crawl_settings"
    expect(response.parsed_body.fetch("product_crawl_settings").pluck("id")).to eq([id])

    put "/api/v1/product_crawl_settings/#{id}", params: params.merge(required_keywords: ["updated"]), as: :json
    expect(response.parsed_body.fetch("required_keywords")).to eq(["updated"])

    delete "/api/v1/product_crawl_settings/#{id}"
    expect(response).to have_http_status(:ok)
    expect(ProductCrawlSetting.exists?(id)).to be(false)
  end

  it "rejects unsupported URLs without changing the saved setting" do
    product_crawl_setting = create(:product_crawl_setting, name: "phone")
    put "/api/v1/product_crawl_settings/#{product_crawl_setting.id}",
        params: params.merge(name: "changed", search_urls: ["https://evil.example/search?q=x"]), as: :json
    expect(response).to have_http_status(:bad_request)
    expect(product_crawl_setting.reload.name).to eq("phone")
  end

  it "rejects an iosys group search when registering a setting" do
    expect do
      post "/api/v1/product_crawl_settings",
           params: params.merge(search_urls: ["https://iosys.co.jp/items?t=g&q=ipad"]), as: :json
    end.not_to change(ProductCrawlSetting, :count)
    expect(response).to have_http_status(:bad_request)
    expect(response.parsed_body.to_s).to include("個別出品", "t=gなし")
  end

  it "syncs saved settings" do
    allow(Crawl::Search::Crawler).to receive(:fetch).and_return([{ external_id: "a", name: "phone", price: 200,
                                                                   product_url: "https://iosys.co.jp/items/a" }])
    product_crawl_setting = create(:product_crawl_setting)
    post "/api/v1/product_crawl_settings/#{product_crawl_setting.id}/sync"
    expect(response).to have_http_status(:ok)
    get "/api/v1/product_crawl_results"
    expect(response.parsed_body.fetch("product_crawl_results").pluck("external_id")).to eq(["a"])
  end

  it "excludes and restores a listing without deleting it" do
    result = create(:product_crawl_result)
    patch "/api/v1/product_crawl_results/#{result.id}", params: { excluded: true }, as: :json
    expect(response).to have_http_status(:ok)
    expect(result.reload.excluded_at).to be_present

    get "/api/v1/product_crawl_results"
    expect(response.parsed_body.fetch("product_crawl_results")).to be_empty
    get "/api/v1/product_crawl_results", params: { product_crawl_setting_id: result.product_crawl_setting_id, excluded: true }
    expect(response.parsed_body.fetch("product_crawl_results").pluck("id")).to eq([result.id])

    patch "/api/v1/product_crawl_results/#{result.id}", params: { excluded: false }, as: :json
    expect(result.reload.excluded_at).to be_nil
  end

end

RSpec.describe "Product crawl results", type: :request do
  it "returns the newest eight per setting and full counts while detail remains unlimited" do
    setting = create(:product_crawl_setting)
    other = create(:product_crawl_setting)
    results = Array.new(10) { |i| create(:product_crawl_result, product_crawl_setting: setting, sold: i.even?) }
    excluded = create(:product_crawl_result, product_crawl_setting: setting, excluded_at: Time.current)
    other_result = create(:product_crawl_result, product_crawl_setting: other)
    get "/api/v1/product_crawl_results"
    expect(response.parsed_body.fetch("product_crawl_results").pluck("id")).to eq([other_result.id] + results.last(8).reverse.map(&:id))
    expect(response.parsed_body.fetch("counts")).to include(
      { "product_crawl_setting_id" => setting.id, "sold" => true, "count" => 5 },
      { "product_crawl_setting_id" => setting.id, "sold" => false, "count" => 5 }
    )
    get "/api/v1/product_crawl_results", params: { product_crawl_setting_id: setting.id }
    expect(response.parsed_body.fetch("product_crawl_results").pluck("id")).to eq(results.reverse.map(&:id))
    get "/api/v1/product_crawl_results", params: { excluded: true }
    expect(response.parsed_body.fetch("product_crawl_results").pluck("id")).to eq([excluded.id])
  end
  it "lists results across crawl settings" do
    first = create(:product_crawl_result)
    second = create(:product_crawl_result)
    get "/api/v1/product_crawl_results"
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.fetch("product_crawl_results").pluck("id")).to eq([second.id, first.id])

    get "/api/v1/product_crawl_results", params: { product_crawl_setting_id: first.product_crawl_setting_id }
    expect(response.parsed_body.fetch("product_crawl_results").pluck("id")).to eq([first.id])
  end
end
