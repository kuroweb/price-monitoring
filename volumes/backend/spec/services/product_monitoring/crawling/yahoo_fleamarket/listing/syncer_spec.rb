require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooFleamarket::Listing::Syncer do
  let(:detail_job) { ProductMonitoring::Crawling::YahooFleamarket::Detail::SyncJob }
  let(:setting) { create(:product_crawl_setting) }
  let(:listings) { [] }

  before do
    allow(ProductMonitoring::Crawling::YahooFleamarket::Listing::Crawler).to receive(:call) do
      { listings: listings.map { |listing| listing.merge(platform: "yahoo_fleamarket") }, complete: true }
    end
    allow(detail_job).to receive(:perform_async)
  end

  def listing(id, **attributes)
    create(:product_crawl_result, product_crawl_setting: setting, platform: "yahoo_fleamarket", external_id: id,
                                  **attributes)
  end

  it "一覧から消えた出品と一覧で初めて売り切れになった出品を確かめること" do
    listing("missing-yahoo", sold: false, updated_at: 4.hours.ago)
    listings << { external_id: "sold-yahoo", price: 100, name: "Phone",
                  product_url: "https://paypayfleamarket.yahoo.co.jp/item/sold-yahoo", sold: true }
    described_class.call(product_crawl_setting: setting)
    expect(detail_job).to have_received(:perform_async).with("missing-yahoo")
    expect(detail_job).to have_received(:perform_async).with("sold-yahoo")
  end

  it "詳細確認の上限を他サイトと別に数えること" do
    stub_const("#{described_class}::MAX_DETAIL_JOBS", 1)
    listing("old-yahoo", sold: false, updated_at: 6.days.ago)
    listing("new-yahoo", sold: false, updated_at: 4.days.ago)
    create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "old-mercari",
                                  sold: false, updated_at: 7.days.ago)
    described_class.call(product_crawl_setting: setting)
    expect(detail_job).to have_received(:perform_async).once
    expect(detail_job).to have_received(:perform_async).with("old-yahoo")
  end
end
