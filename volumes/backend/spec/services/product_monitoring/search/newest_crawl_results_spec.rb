require "rails_helper"

RSpec.describe ProductMonitoring::Search::NewestCrawlResults do
  it "複数バッチから条件に合う商品を売り切れも含めて新着順に重複なく返す" do
    stub_const("ProductMonitoring::Search::NewestCrawlResults::BATCH_SIZE", 2)
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    oldest = create(:product_monitoring_crawl_result, name: "phone", price: 300, sold: false)
    other_platform = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: false,
                                                              platform: "mercari", external_id: "one")
    create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: false, platform: "iosys",
                                             external_id: "one")
    first = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: true, sold_at: Time.current,
                                                     platform: "iosys", external_id: "one")
    create(:product_monitoring_crawl_result, name: "case", price: 50, sold: false)
    create(:product_monitoring_crawl_result, name: "phone", price: 50, sold: false, excluded_at: Time.current)
    newest = create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: nil)

    expect(described_class.call(monitor: setting)).to eq([newest, first, other_platform, oldest])
  end

  it "価格帯の上下限を含めて検索する" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", min_price: 100, max_price: 200)
    lower = create(:product_monitoring_crawl_result, price: 100, sold: true, sold_at: Time.current)
    create(:product_monitoring_crawl_result, price: 99, sold: false)
    upper = create(:product_monitoring_crawl_result, price: 200, sold: false)
    create(:product_monitoring_crawl_result, price: 201, sold: false)

    expect(described_class.call(monitor: setting)).to eq([upper, lower])
  end

  it "8件に達した後の商品を条件判定しない" do
    setting = ProductMonitoring::Monitor.create!(name: "phone")
    older = create(:product_monitoring_crawl_result, sold: false)
    expected = Array.new(8) { create(:product_monitoring_crawl_result, sold: true, sold_at: Time.current) }.reverse

    matcher = ProductMonitoring::Monitor::Matcher
    allow(matcher).to receive(:call).and_call_original
    expect(described_class.call(monitor: setting)).to eq(expected)
    expect(matcher).not_to have_received(:call).with(monitor: setting, listing: older)
  end

  it "条件に合う商品がなければ空を返す" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    create(:product_monitoring_crawl_result, name: "case", price: 100, sold: false)

    expect(described_class.call(monitor: setting)).to eq([])
  end

  it "今日保存した売り切れでも売れた日が古ければ、売れた日が新しい出品より後ろになる" do
    stub_const("ProductMonitoring::Search::NewestCrawlResults::BATCH_SIZE", 2)
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    newer_sale = create(:product_monitoring_crawl_result, name: "phone", sold: true,
                                                          sold_at: Time.zone.parse("2026-11-20 09:00:00"),
                                                          created_at: Time.zone.parse("2026-05-01 09:00:00"))
    older_sale = create(:product_monitoring_crawl_result, name: "phone", sold: true,
                                                          sold_at: Time.zone.parse("2026-05-01 09:00:00"),
                                                          created_at: Time.zone.parse("2026-11-23 09:00:00"))

    expect(described_class.call(monitor: setting)).to eq([newer_sale, older_sale])
  end

  it "売れた日がない売り切れは、保存日時と id が最新でも8件に入らない" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    visible = create(:product_monitoring_crawl_result, name: "phone", sold: false, created_at: 2.days.ago)
    create(:product_monitoring_crawl_result, name: "phone", sold: true, created_at: Time.current)

    expect(described_class.call(monitor: setting)).to eq([visible])
  end

  it "販売中は初めて保存した時刻の新しい順で、再保存で進んだ更新日時では前に出ない" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    first_saved = Time.zone.parse("2026-11-01 12:00:00")
    resaved = create(:product_monitoring_crawl_result, name: "phone", sold: false, created_at: first_saved,
                                                       updated_at: Time.zone.parse("2026-11-23 09:00:00"),
                                                       recency_at: first_saved)
    tied = create(:product_monitoring_crawl_result, name: "phone", sold: false, created_at: first_saved,
                                                    recency_at: first_saved)
    newer = create(:product_monitoring_crawl_result, name: "phone", sold: false,
                                                     created_at: Time.zone.parse("2026-11-20 09:00:00"),
                                                     recency_at: Time.zone.parse("2026-11-20 09:00:00"))

    expect(described_class.call(monitor: setting)).to eq([newer, tied, resaved])
  end

  it "除外する出品者の出品を、出品者IDが不明な別の収集設定の同じ出品も含めて出さないこと" do
    setting = ProductMonitoring::Monitor.create!(name: "phone")
    create(:product_monitoring_excluded_seller, platform: "yahoo_fleamarket", seller_id: "p1")
    create(:product_monitoring_crawl_result, platform: "yahoo_fleamarket", external_id: "z1", seller_id: "p1")
    create(:product_monitoring_crawl_result, platform: "yahoo_fleamarket", external_id: "z1")
    unknown = create(:product_monitoring_crawl_result, platform: "yahoo_fleamarket", external_id: "z2")

    expect(described_class.call(monitor: setting)).to eq([unknown])
  end
end
