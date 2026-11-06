require "rails_helper"

RSpec.describe ProductCrawlSettings::SyncResults do
  let(:product_crawl_setting) { create(:product_crawl_setting, required_keywords: ["phone"]) }

  before do
    allow(Crawl::Search::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone blue", price: 100, product_url: "https://iosys.co.jp/items/a",
        thumbnail_url: "https://iosys.co.jp/a.jpg" },
      { external_id: "b", name: "Case", price: 100, product_url: "https://iosys.co.jp/items/b" },
      { external_id: "excluded", name: "Phone red", price: 300, product_url: "https://iosys.co.jp/items/excluded" }
    ])
  end

  it "saves only accepted listings with their platform" do
    described_class.call(product_crawl_setting:)
    results = product_crawl_setting.product_crawl_results
    expect(results.pluck(:external_id)).to contain_exactly("a", "excluded")
    expect(results.find_by(external_id: "a")).to have_attributes(
      platform: "iosys", product_url: "https://iosys.co.jp/items/a", price: 100, thumbnail_url: "https://iosys.co.jp/a.jpg"
    )
  end

  it "keeps an excluded listing excluded while updating its price" do
    excluded_at = 1.day.ago.change(usec: 0)
    create(:product_crawl_result, product_crawl_setting:, external_id: "excluded", name: "Phone red", price: 100,
                                  excluded_at:)
    result = described_class.call(product_crawl_setting:)
    expect(result[:results].find { |row| row[:external_id] == "excluded" }).to include(accepted: false)
    expect(product_crawl_setting.product_crawl_results.find_by(external_id: "excluded")).to have_attributes(
      price: 300, excluded_at:
    )
  end

  it "keeps listings missing from the latest crawl and removes ones that no longer match" do
    kept = create(:product_crawl_result, product_crawl_setting:, external_id: "sold", name: "Phone sold")
    create(:product_crawl_result, product_crawl_setting:, external_id: "unmatched", name: "Case")
    described_class.call(product_crawl_setting:)
    expect(product_crawl_setting.product_crawl_results.pluck(:external_id)).to contain_exactly("a", "excluded", kept.external_id)
  end

  it "updates an existing listing instead of duplicating it" do
    create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", price: 50)
    described_class.call(product_crawl_setting:)
    expect(product_crawl_setting.product_crawl_results.where(external_id: "a").sole).to have_attributes(
      name: "Phone blue", price: 100
    )
  end

  it "skips listings without a price while retaining existing rows and accepting zero" do
    existing = create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", price: 50)
    allow(Crawl::Search::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone new", price: nil, product_url: "https://iosys.co.jp/items/a" },
      { external_id: "missing", name: "Phone", price: nil, product_url: "https://iosys.co.jp/items/missing" },
      { external_id: "free", name: "Phone", price: 0, product_url: "https://iosys.co.jp/items/free" }
    ])
    described_class.call(product_crawl_setting:)
    expect(existing.reload).to have_attributes(name: "Phone old", price: 50)
    expect(product_crawl_setting.product_crawl_results.pluck(:external_id)).to contain_exactly("a", "free")
  end
end
