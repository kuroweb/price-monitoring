require "rails_helper"

RSpec.describe "商品モニタリング設定", type: :request do
  let(:settings) do
    { name: "phone", enabled: true, discord_enabled: true, required_keywords: ["phone"],
      exclude_keywords: ["case"], min_price: nil, max_price: 1_000 }
  end

  it "設定を登録・取得・更新・削除する" do
    post "/api/v1/product_watch_settings", params: settings, as: :json
    expect(response).to have_http_status(:ok)
    id = response.parsed_body.fetch("id")
    get "/api/v1/product_watch_settings"
    expect(response.parsed_body.fetch("product_watch_settings").pluck("id")).to include(id)
    expect(response.parsed_body).to have_key("discord_configured")
    put "/api/v1/product_watch_settings/#{id}", params: settings.merge(min_price: 2_000), as: :json
    expect(response).to have_http_status(:bad_request)
    put "/api/v1/product_watch_settings/#{id}", params: settings.merge(name: "updated"), as: :json
    expect(response.parsed_body.fetch("name")).to eq("updated")
    delete "/api/v1/product_watch_settings/#{id}"
    expect(ProductWatchSetting.exists?(id)).to be(false)
  end

  it "全計測から条件に一致する販売中の商品を重複なく返す" do
    setting = ProductWatchSetting.create!(settings)
    create(:product_crawl_result, name: "phone", price: 500, sold: false, platform: "iosys", external_id: "one")
    create(:product_crawl_result, name: "phone", price: 500, sold: false, platform: "iosys", external_id: "one")
    create(:product_crawl_result, name: "phone", price: 500, sold: false, platform: "mercari", external_id: "two")
    create(:product_crawl_result, name: "phone case", price: 1, sold: false)
    create(:product_crawl_result, name: "phone", price: 1, sold: true)
    create(:product_crawl_result, name: "phone", price: 1, sold: nil)
    create(:product_crawl_result, name: "phone", price: 1, sold: false, excluded_at: Time.current)
    get "/api/v1/product_watch_settings/#{setting.id}/results"
    expect(response.parsed_body.fetch("product_crawl_results").pluck("external_id")).to eq(%w[one two])
  end

  it "条件に一致する商品を重複を除いて価格順に最大8件返す" do
    setting = ProductWatchSetting.create!(settings)
    create(:product_crawl_result, name: "phone case", price: 1, sold: false)
    expected = (1..9).map do |price|
      create(:product_crawl_result, name: "phone", price: price * 10, sold: false, external_id: "item-#{price}")
    end
    create(:product_crawl_result, name: "phone", price: 10, sold: false, external_id: "item-1")

    get "/api/v1/product_watch_settings/#{setting.id}/results"

    expect(response.parsed_body.fetch("product_crawl_results").pluck("id")).to eq(expected.first(8).map(&:id))
  end
end
