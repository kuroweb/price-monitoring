require "rails_helper"

RSpec.describe "Product search settings", type: :request do
  let(:draft) { { name: "phone", enabled: true, min_price: 100, required_keywords: ["phone"], exclude_keywords: [], excluded_listings: [{ platform: "mercari", external_id: "x" }], urls: [{ url: "https://jp.mercari.com/search?keyword=phone", enabled: true }, { url: "https://iosys.co.jp/items?q=phone", enabled: true }] } }

  it "stores one Product with shared filters and multiple URLs and supports CRUD" do
    expect { post "/api/v1/products/search_settings", params: draft, as: :json }.to change(Product, :count).by(1)
    expect(response).to have_http_status(:ok)
    id = response.parsed_body.fetch("id")
    product = Product.find(id)
    expect(product.search_urls.count).to eq(2)
    expect(product.required_keywords.pluck(:keyword)).to eq(["phone"])
    expect(product.mercari_crawl_setting).to be_nil
    expect(response.parsed_body.fetch("urls").first.keys).to match_array(%w[url enabled])
    get "/api/v1/products/search_settings"
    expect(response.parsed_body.fetch("products").pluck("id")).to eq([id])
    put "/api/v1/products/#{id}/search_settings", params: draft.merge(required_keywords: ["updated"]), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.fetch("required_keywords")).to eq(["updated"])
    delete "/api/v1/products/#{id}"
    expect(response).to have_http_status(:ok)
    expect(ProductSearchUrl.where(product_id: id)).to be_empty
  end

  it "rejects invalid replacements without changing the old Product configuration" do
    post "/api/v1/products/search_settings", params: draft, as: :json
    id = response.parsed_body.fetch("id")
    put "/api/v1/products/#{id}/search_settings", params: draft.merge(name: "changed", urls: [{ url: "https://evil.example/search?q=x" }]), as: :json
    expect(response).to have_http_status(:bad_request)
    expect(Product.find(id).name).to eq("phone")
    expect(Product.find(id).search_urls.count).to eq(2)
  end

  it "delegates real preview and rejects legacy updates of URL Products" do
    expect(Crawl::Search::Preview).to receive(:call).with(params: anything).and_return(sources: [], results: [], fetched_count: 0, accepted_count: 0)
    post "/api/v1/products/preview", params: draft, as: :json
    expect(response).to have_http_status(:ok)
    post "/api/v1/products/search_settings", params: draft, as: :json
    id = response.parsed_body.fetch("id")
    put "/api/v1/products/#{id}", params: { name: "legacy edit" }, as: :json
    expect(response).to have_http_status(:bad_request)
    expect(Product.find(id).name).to eq("phone")
  end

  it "does not enqueue URL-only Products in old site jobs" do
    product = Product.create!(name: "url-only")
    expect(Crawl::Mercari::SyncProducts::SyncJob).to receive(:perform_bulk).with([])
    Crawl::Mercari::SyncProducts::EnqueueSyncJob.new.perform
    expect { Crawl::Iosys::Syncer.call(product: product) }.not_to raise_error
    expect { Products::Inspector::InspectAll.call(product: product) }.not_to raise_error
  end
end
