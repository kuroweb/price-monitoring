require "rails_helper"

RSpec.describe "Product crawl settings", type: :request do
  let(:params) do
    {
      name: "phone", enabled: true, min_price: 100,
      search_urls: ["https://jp.mercari.com/search?keyword=phone", "https://iosys.co.jp/items?q=phone"],
      required_keywords: ["phone"], exclude_keywords: [], exclude_external_ids: []
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

  it "previews without saving and syncs saved settings" do
    allow(Crawl::Search::Preview).to receive(:fetch).and_return([{ external_id: "a", name: "phone", price: 200,
                                                                   product_url: "https://iosys.co.jp/items/a" }])
    post "/api/v1/product_crawl_settings/preview", params:, as: :json
    expect(response.parsed_body.fetch("accepted_count")).to eq(1)
    expect(ProductCrawlResult.count).to eq(0)

    product_crawl_setting = create(:product_crawl_setting)
    post "/api/v1/product_crawl_settings/#{product_crawl_setting.id}/sync"
    expect(response).to have_http_status(:ok)
    get "/api/v1/product_crawl_settings/#{product_crawl_setting.id}/product_crawl_results"
    expect(response.parsed_body.fetch("product_crawl_results").pluck("external_id")).to eq(["a"])
  end

  it "excludes a listing and removes its saved result" do
    result = create(:product_crawl_result)
    post "/api/v1/product_crawl_settings/#{result.product_crawl_setting_id}/exclude_external_ids",
         params: { external_id: result.external_id }, as: :json
    expect(response).to have_http_status(:ok)
    expect(result.product_crawl_setting.reload.exclude_external_ids).to eq([result.external_id])
    expect(ProductCrawlResult.exists?(result.id)).to be(false)
  end
end
