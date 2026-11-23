require "rails_helper"

RSpec.describe ProductMonitoring::Search::MatchingCrawlResults do
  def search(**)
    described_class.call(**)
  end

  it "1ページはグリッド一段の6件である" do
    expect(described_class::PAGE_SIZE).to eq(6)
  end

  it "新着順の recency_at と id の降順インデックスがある" do
    index = ActiveRecord::Base.connection.indexes("product_monitoring_crawl_results")
                              .find { |item| item.columns == %w[recency_at id] }

    expect(index).to have_attributes(columns: %w[recency_at id], orders: :desc)
  end

  it "売れた日が古い売り切れ、売れた日がない売り切れ、販売中を新着順に分け、同じ時刻は id の降順にする" do
    stub_const("ProductMonitoring::Search::MatchingCrawlResults::BATCH_SIZE", 2)
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    undated_lower = create(:product_monitoring_crawl_result, name: "phone", price: 800, sold: true,
                                                             external_id: "undated-lower")
    on_sale_older = create(:product_monitoring_crawl_result, name: "phone", price: 500, sold: false,
                                                             recency_at: Time.zone.parse("2026-05-01 09:00:00"),
                                                             external_id: "on-sale-older")
    old_sold = create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: true,
                                                        sold_at: Time.zone.parse("2026-01-01 09:00:00"),
                                                        recency_at: Time.zone.parse("2026-01-01 09:00:00"),
                                                        external_id: "old-sold")
    same_time_lower = create(:product_monitoring_crawl_result, name: "phone", price: 300, sold: false,
                                                               recency_at: Time.zone.parse("2026-11-20 09:00:00"),
                                                               external_id: "same-lower")
    same_time_higher = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: nil,
                                                                recency_at: Time.zone.parse("2026-11-20 09:00:00"),
                                                                external_id: "same-higher")
    undated_higher = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: true,
                                                              external_id: "undated-higher")
    create(:product_monitoring_crawl_result, name: "case", price: 50, sold: false)
    create(:product_monitoring_crawl_result, name: "phone", price: 50, sold: false, excluded_at: Time.current)
    create(:product_monitoring_crawl_result, name: "phone", price: 150, sold: true,
                                             sold_at: Time.zone.parse("2020-01-01 00:00:00"),
                                             recency_at: Time.zone.parse("2020-01-01 00:00:00"),
                                             platform: same_time_higher.platform,
                                             external_id: same_time_higher.external_id)
    create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: true,
                                             platform: old_sold.platform, external_id: old_sold.external_id)

    expected = [same_time_higher, same_time_lower, on_sale_older, old_sold, undated_higher, undated_lower]
    page = search(monitor: setting, sale_status: "all", sort: "newest", page: 1)

    expect(page.listings).to eq(expected)
    expect(page.has_more).to be(false)
  end

  it "続きのページを返し、1ページと続きの有無が分かった時点で走査を終える" do
    stub_const("ProductMonitoring::Search::MatchingCrawlResults::PAGE_SIZE", 2)
    stub_const("ProductMonitoring::Search::MatchingCrawlResults::BATCH_SIZE", 2)
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    oldest = create(:product_monitoring_crawl_result, name: "phone", sold: false, external_id: "oldest",
                                                      recency_at: Time.zone.parse("2026-11-01 09:00:00"))
    middle = create(:product_monitoring_crawl_result, name: "phone", sold: false, external_id: "middle",
                                                      recency_at: Time.zone.parse("2026-11-02 09:00:00"))
    newer = create(:product_monitoring_crawl_result, name: "phone", sold: false, external_id: "newer",
                                                     recency_at: Time.zone.parse("2026-11-03 09:00:00"))
    newest = create(:product_monitoring_crawl_result, name: "phone", sold: false, external_id: "newest",
                                                      recency_at: Time.zone.parse("2026-11-04 09:00:00"))
    matcher = ProductMonitoring::Monitor::Matcher
    allow(matcher).to receive(:call).and_call_original

    first = search(monitor: setting, page: 1)
    expect(first.listings).to eq([newest, newer])
    expect(first.has_more).to be(true)
    expect(matcher).not_to have_received(:call).with(monitor: setting, listing: oldest)

    second = search(monitor: setting, page: 2)
    expect(second.listings).to eq([middle, oldest])
    expect(second.has_more).to be(false)
  end

  it "売れた日が無い売り切れをページの末尾に残し、売り切れとすべてから落とさない" do
    stub_const("ProductMonitoring::Search::MatchingCrawlResults::PAGE_SIZE", 2)
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    undated = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: true, external_id: "undated")
    older = create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: false, external_id: "older",
                                                     recency_at: Time.zone.parse("2026-11-01 09:00:00"))
    newer = create(:product_monitoring_crawl_result, name: "phone", price: 300, sold: false, external_id: "newer",
                                                     recency_at: Time.zone.parse("2026-11-02 09:00:00"))

    first = search(monitor: setting, sale_status: "all", sort: "newest", page: 1)
    expect(first.listings).to eq([newer, older])
    expect(first.has_more).to be(true)
    second = search(monitor: setting, sale_status: "all", sort: "newest", page: 2)
    expect(second.listings).to eq([undated])

    sold = search(monitor: setting, sale_status: "sold", sort: "newest", page: 1)
    expect(sold.listings).to eq([undated])
    on_sale = search(monitor: setting, sale_status: "on_sale", sort: "newest", page: 1)
    expect(on_sale.listings).to eq([newer, older])
  end

  it "価格順は同じ価格を id の降順にし、販売状態が不明な行を販売中に含める" do
    stub_const("ProductMonitoring::Search::MatchingCrawlResults::PAGE_SIZE", 2)
    setting = ProductMonitoring::Monitor.create!(name: "phone")
    same_lower = create(:product_monitoring_crawl_result, price: 100, sold: false, external_id: "same-lower")
    same_higher = create(:product_monitoring_crawl_result, price: 100, sold: nil, external_id: "same-higher")
    expensive = create(:product_monitoring_crawl_result, price: 500, sold: true, external_id: "expensive",
                                                         sold_at: Time.zone.parse("2026-01-01 09:00:00"))
    undated = create(:product_monitoring_crawl_result, price: 50, sold: true, external_id: "undated")

    cheap = search(monitor: setting, sale_status: "all", sort: "price_asc", page: 1)
    expect(cheap.listings).to eq([undated, same_higher])
    expect(cheap.has_more).to be(true)
    rest = search(monitor: setting, sale_status: "all", sort: "price_asc", page: 2)
    expect(rest.listings).to eq([same_lower, expensive])

    high = search(monitor: setting, sale_status: "on_sale", sort: "price_desc", page: 1)
    expect(high.listings).to eq([same_higher, same_lower])
    expect(high.has_more).to be(false)
  end

  it "価格帯の上下限を含め、売れた日がない売り切れも対象にする" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", min_price: 100, max_price: 200)
    lower = create(:product_monitoring_crawl_result, price: 100, sold: true,
                                                     sold_at: Time.zone.parse("2026-02-01 09:00:00"),
                                                     recency_at: Time.zone.parse("2026-02-01 09:00:00"))
    create(:product_monitoring_crawl_result, price: 99, sold: false)
    upper = create(:product_monitoring_crawl_result, price: 200, sold: false,
                                                     recency_at: Time.zone.parse("2026-11-20 09:00:00"))
    create(:product_monitoring_crawl_result, price: 201, sold: false)
    undated = create(:product_monitoring_crawl_result, price: 150, sold: true)

    expect(search(monitor: setting).listings).to eq([upper, lower, undated])
  end

  it "条件に合う商品がなければ空のページを返す" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    create(:product_monitoring_crawl_result, name: "case", price: 100, sold: false)

    page = search(monitor: setting)
    expect(page.listings).to eq([])
    expect(page.has_more).to be(false)
  end

  it "販売状態、並び、page が不正なら拒否する" do
    setting = ProductMonitoring::Monitor.create!(name: "phone")

    expect { search(monitor: setting, sale_status: "other") }.to raise_error(ArgumentError)
    expect { search(monitor: setting, sort: "name") }.to raise_error(ArgumentError)
    expect { search(monitor: setting, page: 0) }.to raise_error(ArgumentError)
    expect { search(monitor: setting, page: "next") }.to raise_error(ArgumentError)
  end
end
