require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Mercari::ListPage::Syncer do
  let(:detail_job) { ProductMonitoring::Crawling::Mercari::DetailPage::SyncJob }
  let(:setting) { create(:product_monitoring_crawl_setting) }
  let(:complete) { true }
  let(:listings) do
    [{ external_id: "visible", price: 100, name: "Phone", product_url: "https://jp.mercari.com/item/visible",
       sold: false }]
  end

  before do
    allow(ProductMonitoring::Crawling::Mercari::ListPage::Crawler).to receive(:call) do
      { listings: listings.map { |listing| listing.merge(platform: "mercari") }, complete: }
    end
    allow(detail_job).to receive(:perform_async)
  end

  def listing(id, **attributes)
    create(:product_monitoring_crawl_result, crawl_setting: setting, platform: "mercari", external_id: id, **attributes)
  end

  it "一覧から消えた出品と売れた日のない出品を確かめ、一覧にある出品や他サイトの出品は確かめないこと" do
    listing("missing", sold: false, updated_at: 4.hours.ago)
    listing("undated", sold: true, updated_at: 4.hours.ago)
    create(:product_monitoring_crawl_result, crawl_setting: setting, platform: "iosys", external_id: "iosys",
                                             sold: false,
                                             updated_at: 4.hours.ago)
    described_class.call(crawl_setting: setting)
    expect(detail_job).to have_received(:perform_async).with("missing")
    expect(detail_job).to have_received(:perform_async).with("undated")
    expect(detail_job).not_to have_received(:perform_async).with("visible")
    expect(detail_job).not_to have_received(:perform_async).with("iosys")
  end

  it "一覧から消えた販売中の出品は3時間待ってから確かめること" do
    listing("recent", sold: false, updated_at: 2.hours.ago)
    listing("old", sold: false, updated_at: 4.hours.ago)
    described_class.call(crawl_setting: setting)
    expect(detail_job).not_to have_received(:perform_async).with("recent")
    expect(detail_job).to have_received(:perform_async).with("old")
  end

  it "詳細で削除された出品はどの収集設定からも再確認せず、同じIDの別サイトの行は保持すること" do
    other_setting = create(:product_monitoring_crawl_setting)
    first = listing("missing", sold: false, updated_at: 4.hours.ago)
    second = listing("missing", crawl_setting: other_setting, sold: true, sold_at: 2.days.ago)
    other_site = listing("missing", crawl_setting: create(:product_monitoring_crawl_setting),
                                    platform: "yahoo_fleamarket", sold: false, updated_at: 4.hours.ago)
    listing("still_due", sold: false, updated_at: 4.hours.ago)
    allow(ProductMonitoring::Crawling::Mercari::DetailPage::Crawler).to receive(:call)
      .with(external_id: "missing").and_return(deleted: true)

    detail_job.new.perform("missing")
    expect(ProductMonitoring::CrawlResult.where(id: [first.id, second.id])).to be_empty
    expect(other_site.reload.sold).to be false

    [setting, other_setting].each { |target| described_class.call(crawl_setting: target) }
    expect(detail_job).not_to have_received(:perform_async).with("missing")
    expect(detail_job).to have_received(:perform_async).with("still_due")
  end

  it "売れた日のない出品は3時間待ってから確かめること" do
    listing("recent", sold: true, updated_at: 2.hours.ago)
    listing("old", sold: true, updated_at: 4.hours.ago)
    described_class.call(crawl_setting: setting)
    expect(detail_job).not_to have_received(:perform_async).with("recent")
    expect(detail_job).to have_received(:perform_async).with("old")
  end

  it "販売中の再保存では並び時刻を進めず、売れた日のない売り切れは空にすること" do
    saved_at = Time.zone.parse("2026-11-01 12:00:00")
    kept = listing("visible", sold: false, created_at: saved_at, recency_at: saved_at)
    listings << { external_id: "undated-sold", price: 100, name: "Phone", sold: true,
                  product_url: "https://jp.mercari.com/item/undated-sold" }

    described_class.call(crawl_setting: setting)

    expect(kept.reload.recency_at).to eq(saved_at)
    expect(setting.crawl_results.find_by!(external_id: "undated-sold"))
      .to have_attributes(sold: true, sold_at: nil, recency_at: nil)
  end

  it "一覧で初めて売り切れになった出品はすぐ確かめること" do
    listing("changed", sold: false)
    %w[new changed].each do |id|
      listings << { external_id: id, price: 100, name: "Phone", product_url: "https://jp.mercari.com/item/#{id}",
                    sold: true }
    end
    described_class.call(crawl_setting: setting)
    expect(detail_job).to have_received(:perform_async).with("new")
    expect(detail_job).to have_received(:perform_async).with("changed")
  end

  it "詳細確認は古い順に上限まで積むこと" do
    stub_const("#{described_class}::MAX_DETAIL_JOBS", 2)
    allow(Rails.logger).to receive(:info).and_call_original
    3.times { |n| listing("m#{n}", sold: false, updated_at: (3 - n).days.ago) }
    described_class.call(crawl_setting: setting)
    expect(detail_job).to have_received(:perform_async).with("m0")
    expect(detail_job).to have_received(:perform_async).with("m1")
    expect(detail_job).not_to have_received(:perform_async).with("m2")
    expect(Rails.logger).to have_received(:info)
      .with("Product crawl detail candidates: setting_id=#{setting.id} platform=mercari candidates=3 enqueued=2")
  end

  context "一覧の取得に失敗したURLがあるとき" do
    let(:complete) { false }

    it "一覧から消えた出品は確かめず、売れた日のない出品だけを確かめること" do
      listing("missing", sold: false, updated_at: 4.hours.ago)
      listing("undated", sold: true, updated_at: 4.hours.ago)
      described_class.call(crawl_setting: setting)
      expect(detail_job).not_to have_received(:perform_async).with("missing")
      expect(detail_job).to have_received(:perform_async).with("undated")
    end
  end

  it "一覧で分かった出品者IDを保存し、更新日時は進めず、一覧で分からないときは既知の出品者IDを空で上書きしないこと" do
    found = { external_id: "with-seller", price: 100, name: "Phone", sold: false,
              product_url: "https://jp.mercari.com/item/with-seller" }
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
