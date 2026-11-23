require "rails_helper"

RSpec.describe ProductMonitoring::Search::MatchingCrawlResults do
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
    expect(described_class.call(monitor: setting)).to eq(expected)
  end

  it "8件で打ち切らず、条件に合う保存済みをすべて返す" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    results = Array.new(9) do |index|
      create(:product_monitoring_crawl_result, name: "phone", sold: false, external_id: "item-#{index}",
                                               recency_at: Time.zone.parse("2026-11-01 09:00:00") + index.days)
    end

    expect(described_class.call(monitor: setting)).to eq(results.reverse)
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

    expect(described_class.call(monitor: setting)).to eq([upper, lower, undated])
  end

  it "条件に合う商品がなければ空を返す" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    create(:product_monitoring_crawl_result, name: "case", price: 100, sold: false)

    expect(described_class.call(monitor: setting)).to eq([])
  end
end
