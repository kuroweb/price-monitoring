require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Mercari::Listing::Syncer do
  let(:detail_job) { ProductMonitoring::Crawling::Mercari::Detail::SyncJob }
  let(:setting) { create(:product_crawl_setting) }
  let(:complete) { true }
  let(:listings) do
    [{ external_id: "visible", price: 100, name: "Phone", product_url: "https://jp.mercari.com/item/visible",
       sold: false }]
  end

  before do
    allow(ProductMonitoring::Crawling::Mercari::Listing::Crawler).to receive(:call) do
      { listings: listings.map { |listing| listing.merge(platform: "mercari") }, complete: }
    end
    allow(detail_job).to receive(:perform_async)
  end

  def listing(id, **attributes)
    create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: id, **attributes)
  end

  it "一覧から消えた出品と売れた日のない出品を確かめ、一覧にある出品や他サイトの出品は確かめないこと" do
    listing("missing", sold: false, updated_at: 4.hours.ago)
    listing("undated", sold: true, updated_at: 4.hours.ago)
    create(:product_crawl_result, product_crawl_setting: setting, platform: "iosys", external_id: "iosys", sold: false,
                                  updated_at: 4.hours.ago)
    described_class.call(product_crawl_setting: setting)
    expect(detail_job).to have_received(:perform_async).with("missing")
    expect(detail_job).to have_received(:perform_async).with("undated")
    expect(detail_job).not_to have_received(:perform_async).with("visible")
    expect(detail_job).not_to have_received(:perform_async).with("iosys")
  end

  it "一覧から消えた販売中の出品は3時間待ってから確かめること" do
    listing("recent", sold: false, updated_at: 2.hours.ago)
    listing("old", sold: false, updated_at: 4.hours.ago)
    described_class.call(product_crawl_setting: setting)
    expect(detail_job).not_to have_received(:perform_async).with("recent")
    expect(detail_job).to have_received(:perform_async).with("old")
  end

  it "売れた日のない出品は3時間待ってから確かめること" do
    listing("recent", sold: true, updated_at: 2.hours.ago)
    listing("old", sold: true, updated_at: 4.hours.ago)
    described_class.call(product_crawl_setting: setting)
    expect(detail_job).not_to have_received(:perform_async).with("recent")
    expect(detail_job).to have_received(:perform_async).with("old")
  end

  it "一覧で初めて売り切れになった出品はすぐ確かめること" do
    listing("changed", sold: false)
    %w[new changed].each do |id|
      listings << { external_id: id, price: 100, name: "Phone", product_url: "https://jp.mercari.com/item/#{id}", sold: true }
    end
    described_class.call(product_crawl_setting: setting)
    expect(detail_job).to have_received(:perform_async).with("new")
    expect(detail_job).to have_received(:perform_async).with("changed")
  end

  it "詳細確認は古い順に上限まで積むこと" do
    stub_const("#{described_class}::MAX_DETAIL_JOBS", 2)
    allow(Rails.logger).to receive(:info).and_call_original
    3.times { |n| listing("m#{n}", sold: false, updated_at: (3 - n).days.ago) }
    described_class.call(product_crawl_setting: setting)
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
      described_class.call(product_crawl_setting: setting)
      expect(detail_job).not_to have_received(:perform_async).with("missing")
      expect(detail_job).to have_received(:perform_async).with("undated")
    end
  end
end
