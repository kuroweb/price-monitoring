require "rails_helper"

RSpec.describe "商品クロール設定", type: :request do
  let(:params) do
    {
      name: "phone", enabled: true, min_price: 100,
      search_urls: ["https://jp.mercari.com/search?search_keyword=phone", "https://iosys.co.jp/items?q=phone"],
      required_keywords: ["phone"], negative_keywords: []
    }
  end

  it "検索 URL とフィルターをまとめて作成・取得・更新・削除すること" do
    expect { post "/api/v1/product_monitoring/crawl_settings", params:, as: :json }.to change(ProductMonitoring::CrawlSetting, :count).by(1)
    expect(response).to have_http_status(:ok)
    id = response.parsed_body.fetch("id")
    expect(ProductMonitoring::CrawlSetting.find(id).search_urls.size).to eq(2)

    get "/api/v1/product_monitoring/crawl_settings"
    expect(response.parsed_body.fetch("crawl_settings").pluck("id")).to eq([id])

    put "/api/v1/product_monitoring/crawl_settings/#{id}", params: params.merge(required_keywords: ["updated"]), as: :json
    expect(response.parsed_body.fetch("required_keywords")).to eq(["updated"])

    delete "/api/v1/product_monitoring/crawl_settings/#{id}"
    expect(response).to have_http_status(:ok)
    expect(ProductMonitoring::CrawlSetting.exists?(id)).to be(false)
  end

  context "保存済みの結果がある設定を更新するとき" do
    let(:crawl_setting) do
      create(:product_monitoring_crawl_setting, params.slice(:name, :enabled, :min_price, :search_urls, :required_keywords))
    end
    let!(:kept) { create(:product_monitoring_crawl_result, crawl_setting:, name: "phone pro", price: 500) }
    let!(:unmatched) { create(:product_monitoring_crawl_result, crawl_setting:, name: "phone case", price: 200) }

    {
      required_keywords: [%w[phone pro], :kept],
      negative_keywords: [["case"], :kept],
      min_price: [300, :kept],
      max_price: [300, :unmatched]
    }.each do |key, (value, remaining)|
      it "#{key} を変えると新しい条件に一致しない結果を削除すること" do
        put "/api/v1/product_monitoring/crawl_settings/#{crawl_setting.id}", params: params.merge(key => value), as: :json
        expect(response).to have_http_status(:ok)
        expect(crawl_setting.crawl_results.pluck(:id)).to eq([public_send(remaining).id])
      end
    end

    it "条件以外だけを変えると結果を削除しないこと" do
      allow(ProductMonitoring::Crawling::CrawlResultCleaner).to receive(:call)
      put "/api/v1/product_monitoring/crawl_settings/#{crawl_setting.id}",
          params: params.merge(name: "changed", enabled: false), as: :json
      expect(response).to have_http_status(:ok)
      expect(ProductMonitoring::Crawling::CrawlResultCleaner).not_to have_received(:call)
      expect(crawl_setting.crawl_results.pluck(:id)).to contain_exactly(kept.id, unmatched.id)
    end
  end

  it "未対応の URL を拒否し保存済みの設定を変更しないこと" do
    crawl_setting = create(:product_monitoring_crawl_setting, name: "phone")
    put "/api/v1/product_monitoring/crawl_settings/#{crawl_setting.id}",
        params: params.merge(name: "changed", search_urls: ["https://evil.example/search?q=x"]), as: :json
    expect(response).to have_http_status(:bad_request)
    expect(crawl_setting.reload.name).to eq("phone")
  end

  it "設定の登録時に iosys のグループ検索を拒否すること" do
    expect do
      post "/api/v1/product_monitoring/crawl_settings",
           params: params.merge(search_urls: ["https://iosys.co.jp/items?t=g&q=ipad"]), as: :json
    end.not_to change(ProductMonitoring::CrawlSetting, :count)
    expect(response).to have_http_status(:bad_request)
    expect(response.parsed_body.to_s).to include("個別出品", "t=gなし")
  end

  it "無効な設定でも手動同期を投入すること" do
    sync_job = ProductMonitoring::Crawling::Iosys::ListPage::SyncJob
    allow(sync_job).to receive(:perform_async)
    crawl_setting = create(:product_monitoring_crawl_setting, enabled: false, search_urls: ["https://iosys.co.jp/items?q=x"])
    post "/api/v1/product_monitoring/crawl_settings/#{crawl_setting.id}/sync"
    expect(response).to have_http_status(:accepted)
    expect(sync_job).to have_received(:perform_async).with(crawl_setting.id, true)
  end

  it "出品を削除せずに除外と復元を行うこと" do
    result = create(:product_monitoring_crawl_result)
    patch "/api/v1/product_monitoring/crawl_results/#{result.id}", params: { excluded: true }, as: :json
    expect(response).to have_http_status(:ok)
    expect(result.reload.excluded_at).to be_present

    get "/api/v1/product_monitoring/crawl_results"
    expect(response.parsed_body.fetch("crawl_results")).to be_empty
    get "/api/v1/product_monitoring/crawl_results", params: { crawl_setting_id: result.crawl_setting_id, excluded: true }
    expect(response.parsed_body.fetch("crawl_results").pluck("id")).to eq([result.id])

    patch "/api/v1/product_monitoring/crawl_results/#{result.id}", params: { excluded: false }, as: :json
    expect(result.reload.excluded_at).to be_nil
  end

end

RSpec.describe "検索ワードによる収集設定", type: :request do
  it "検索ワードとサイトを保存して取得・更新すること" do
    post "/api/v1/product_monitoring/crawl_settings", params: { name: "検索", search_keyword: " phone ", platforms: ["yahoo_auction"] }, as: :json
    expect(response).to have_http_status(:ok)
    id = response.parsed_body.fetch("id")
    expect(response.parsed_body.slice("search_keyword", "platforms", "search_urls")).to eq(
      "search_keyword" => "phone", "platforms" => ["yahoo_auction"], "search_urls" => []
    )
    put "/api/v1/product_monitoring/crawl_settings/#{id}", params: { name: "検索", search_keyword: "tablet", platforms: ["iosys"] }, as: :json
    expect(response).to have_http_status(:ok)
    expect(ProductMonitoring::CrawlSetting.find(id).attributes.slice("search_keyword", "platforms")).to eq("search_keyword" => "tablet", "platforms" => ["iosys"])
  end

  it "片方だけの入力や未対応サイトを URL があっても拒否すること" do
    base = { name: "検索", search_urls: ["https://iosys.co.jp/items?q=x"] }
    [{ search_keyword: "phone" }, { platforms: ["iosys"] }, { search_keyword: "phone", platforms: ["unknown"] }].each do |values|
      post "/api/v1/product_monitoring/crawl_settings", params: base.merge(values), as: :json
      expect(response).to have_http_status(:bad_request)
    end
  end

  it "Yahoo!フリマに使えない検索ワードを理由とともに拒否すること" do
    ["iPad/Pro", "iPad\nPro"].each do |search_keyword|
      post "/api/v1/product_monitoring/crawl_settings",
           params: { name: "検索", search_keyword: search_keyword, platforms: %w[iosys yahoo_fleamarket] }, as: :json
      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body.to_s).to include("Yahoo!フリマの検索ワードには / と制御文字を使用できません")
    end
  end

  it "他のサイトではスラッシュを含む検索ワードを保存すること" do
    post "/api/v1/product_monitoring/crawl_settings",
         params: { name: "検索", search_keyword: "iPad/Pro", platforms: ["iosys"] }, as: :json
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.fetch("search_keyword")).to eq("iPad/Pro")
  end
end
