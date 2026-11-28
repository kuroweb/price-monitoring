require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooFleamarket::ListPage::Syncer do
  let(:detail_job) { ProductMonitoring::Crawling::YahooFleamarket::DetailPage::SyncJob }
  let(:setting) { create(:product_monitoring_crawl_setting) }
  let(:listings) { [] }

  before do
    allow(ProductMonitoring::Crawling::YahooFleamarket::ListPage::Crawler).to receive(:call) do
      { listings: listings.map { |listing| listing.merge(platform: "yahoo_fleamarket") }, complete: true }
    end
    allow(detail_job).to receive(:perform_async)
  end

  def listing(id, **attributes)
    create(:product_monitoring_crawl_result, crawl_setting: setting, platform: "yahoo_fleamarket", external_id: id,
                                             **attributes)
  end

  it "一覧から消えた出品と一覧で初めて売り切れになった出品を確かめること" do
    listing("missing-yahoo", sold: false, updated_at: 4.hours.ago)
    listings << { external_id: "sold-yahoo", price: 100, name: "Phone",
                  product_url: "https://paypayfleamarket.yahoo.co.jp/item/sold-yahoo", sold: true }
    described_class.call(crawl_setting: setting)
    expect(detail_job).to have_received(:perform_async).with("missing-yahoo")
    expect(detail_job).to have_received(:perform_async).with("sold-yahoo")
  end

  it "詳細確認の上限を他サイトと別に数えること" do
    stub_const("#{described_class}::MAX_DETAIL_JOBS", 1)
    listing("old-yahoo", sold: false, updated_at: 6.days.ago)
    listing("new-yahoo", sold: false, updated_at: 4.days.ago)
    create(:product_monitoring_crawl_result, crawl_setting: setting, platform: "mercari", external_id: "old-mercari",
                                             sold: false, updated_at: 7.days.ago)
    described_class.call(crawl_setting: setting)
    expect(detail_job).to have_received(:perform_async).once
    expect(detail_job).to have_received(:perform_async).with("old-yahoo")
  end

  it "一覧で分かった出品者IDを保存し、更新日時は進めず、一覧で分からないときは既知の出品者IDを空で上書きしないこと" do
    found = { external_id: "with-seller", price: 100, name: "Phone", sold: false,
              product_url: "https://paypayfleamarket.yahoo.co.jp/item/with-seller" }
    listings << found.merge(seller_id: "Seller_1")
    described_class.call(crawl_setting: setting)
    saved = setting.crawl_results.find_by!(external_id: "with-seller")
    expect(saved.seller_id).to eq("Seller_1")

    checked_at = 4.hours.ago.change(usec: 0)
    saved.update_columns(seller_id: nil, updated_at: checked_at) # rubocop:disable Rails/SkipsModelValidations
    described_class.call(crawl_setting: setting)
    expect(saved.reload).to have_attributes(seller_id: "Seller_1", updated_at: checked_at)

    listings[-1] = found.merge(seller_id: nil)
    described_class.call(crawl_setting: setting)
    expect(saved.reload.seller_id).to eq("Seller_1")
  end
end
