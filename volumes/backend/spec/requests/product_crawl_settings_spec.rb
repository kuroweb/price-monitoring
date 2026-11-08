require "rails_helper"

RSpec.describe "商品クロール設定", type: :request do
  let(:params) do
    {
      name: "phone", enabled: true, min_price: 100,
      search_urls: ["https://jp.mercari.com/search?keyword=phone", "https://iosys.co.jp/items?q=phone"],
      required_keywords: ["phone"], exclude_keywords: []
    }
  end

  it "検索 URL とフィルターをまとめて作成・取得・更新・削除すること" do
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

  context "保存済みの結果がある設定を更新するとき" do
    let(:product_crawl_setting) do
      create(:product_crawl_setting, params.slice(:name, :enabled, :min_price, :search_urls, :required_keywords))
    end
    let!(:kept) { create(:product_crawl_result, product_crawl_setting:, name: "phone pro", price: 500) }
    let!(:unmatched) { create(:product_crawl_result, product_crawl_setting:, name: "phone case", price: 200) }

    {
      required_keywords: [%w[phone pro], :kept],
      exclude_keywords: [["case"], :kept],
      min_price: [300, :kept],
      max_price: [300, :unmatched]
    }.each do |key, (value, remaining)|
      it "#{key} を変えると新しい条件に一致しない結果を削除すること" do
        put "/api/v1/product_crawl_settings/#{product_crawl_setting.id}", params: params.merge(key => value), as: :json
        expect(response).to have_http_status(:ok)
        expect(product_crawl_setting.product_crawl_results.pluck(:id)).to eq([public_send(remaining).id])
      end
    end

    it "条件以外だけを変えると結果を削除しないこと" do
      allow(ProductMonitoring::CleanseCrawlResults).to receive(:call)
      put "/api/v1/product_crawl_settings/#{product_crawl_setting.id}",
          params: params.merge(name: "changed", enabled: false), as: :json
      expect(response).to have_http_status(:ok)
      expect(ProductMonitoring::CleanseCrawlResults).not_to have_received(:call)
      expect(product_crawl_setting.product_crawl_results.pluck(:id)).to contain_exactly(kept.id, unmatched.id)
    end
  end

  it "未対応の URL を拒否し保存済みの設定を変更しないこと" do
    product_crawl_setting = create(:product_crawl_setting, name: "phone")
    put "/api/v1/product_crawl_settings/#{product_crawl_setting.id}",
        params: params.merge(name: "changed", search_urls: ["https://evil.example/search?q=x"]), as: :json
    expect(response).to have_http_status(:bad_request)
    expect(product_crawl_setting.reload.name).to eq("phone")
  end

  it "設定の登録時に iosys のグループ検索を拒否すること" do
    expect do
      post "/api/v1/product_crawl_settings",
           params: params.merge(search_urls: ["https://iosys.co.jp/items?t=g&q=ipad"]), as: :json
    end.not_to change(ProductCrawlSetting, :count)
    expect(response).to have_http_status(:bad_request)
    expect(response.parsed_body.to_s).to include("個別出品", "t=gなし")
  end

  it "無効な設定でも手動同期を投入すること" do
    allow(ProductMonitoring::CrawlJob).to receive(:perform_async)
    product_crawl_setting = create(:product_crawl_setting, enabled: false)
    post "/api/v1/product_crawl_settings/#{product_crawl_setting.id}/sync"
    expect(response).to have_http_status(:accepted)
    expect(ProductMonitoring::CrawlJob).to have_received(:perform_async).with(product_crawl_setting.id, true)
  end

  it "出品を削除せずに除外と復元を行うこと" do
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

RSpec.describe "商品クロール結果", type: :request do
  it "設定ごとに最新の 8 件と全件数を返し詳細は件数を制限しないこと" do
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

  it "クロール設定を横断して結果を一覧表示すること" do
    first = create(:product_crawl_result)
    second = create(:product_crawl_result)
    get "/api/v1/product_crawl_results"
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.fetch("product_crawl_results").pluck("id")).to eq([second.id, first.id])

    get "/api/v1/product_crawl_results", params: { product_crawl_setting_id: first.product_crawl_setting_id }
    expect(response.parsed_body.fetch("product_crawl_results").pluck("id")).to eq([first.id])
  end
end

RSpec.describe "検索語による商品計測設定", type: :request do
  it "検索語とサイトを保存して取得・更新すること" do
    post "/api/v1/product_crawl_settings", params: { name: "検索", keyword: " phone ", platforms: ["yahoo_auction"] }, as: :json
    expect(response).to have_http_status(:ok)
    id = response.parsed_body.fetch("id")
    expect(response.parsed_body.slice("keyword", "platforms", "search_urls")).to eq(
      "keyword" => "phone", "platforms" => ["yahoo_auction"], "search_urls" => []
    )
    put "/api/v1/product_crawl_settings/#{id}", params: { name: "検索", keyword: "tablet", platforms: ["iosys"] }, as: :json
    expect(response).to have_http_status(:ok)
    expect(ProductCrawlSetting.find(id).attributes.slice("keyword", "platforms")).to eq("keyword" => "tablet", "platforms" => ["iosys"])
  end

  it "片方だけの入力や未対応サイトを URL があっても拒否すること" do
    [{ keyword: "phone" }, { platforms: ["iosys"] }, { keyword: "phone", platforms: ["unknown"] }].each do |values|
      post "/api/v1/product_crawl_settings", params: { name: "検索", search_urls: ["https://iosys.co.jp/items?q=x"] }.merge(values), as: :json
      expect(response).to have_http_status(:bad_request)
    end
  end
end
