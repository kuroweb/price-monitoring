require "rails_helper"

RSpec.describe ProductCrawlSettings::SyncResults do
  let(:product_crawl_setting) do
    create(:product_crawl_setting, required_keywords: ["phone"], exclude_external_ids: ["excluded"])
  end

  before do
    allow(Crawl::Search::Preview).to receive(:fetch).and_return([
                                                                  { external_id: "a", name: "Phone blue", price: 100,
                                                                    product_url: "https://iosys.co.jp/items/a", thumbnail_url: "https://iosys.co.jp/a.jpg" },
                                                                  { external_id: "b", name: "Case", price: 100,
                                                                    product_url: "https://iosys.co.jp/items/b" },
                                                                  { external_id: "excluded", name: "Phone red",
                                                                    price: 100, product_url: "https://iosys.co.jp/items/excluded" }
                                                                ])
  end

  it "saves only accepted listings with their platform" do
    described_class.call(product_crawl_setting:)
    results = product_crawl_setting.product_crawl_results
    expect(results.pluck(:external_id)).to eq(["a"])
    expect(results.first).to have_attributes(platform: "iosys", product_url: "https://iosys.co.jp/items/a", price: 100, thumbnail_url: "https://iosys.co.jp/a.jpg")
  end

  it "keeps listings missing from the latest crawl and removes ones that no longer match" do
    kept = create(:product_crawl_result, product_crawl_setting:, external_id: "sold", name: "Phone sold")
    create(:product_crawl_result, product_crawl_setting:, external_id: "unmatched", name: "Case")
    described_class.call(product_crawl_setting:)
    expect(product_crawl_setting.product_crawl_results.pluck(:external_id)).to contain_exactly("a", kept.external_id)
  end

  it "updates an existing listing instead of duplicating it" do
    create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", price: 50)
    described_class.call(product_crawl_setting:)
    expect(product_crawl_setting.product_crawl_results.where(external_id: "a").sole).to have_attributes(
      name: "Phone blue", price: 100
    )
  end
end
