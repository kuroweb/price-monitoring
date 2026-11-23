# モニタリング設定の詳細をローカルで見るための開発データ。
# development 以外では何もしない。本番の起動経路からは呼ばない。
return unless Rails.env.development?

setting = ProductMonitoring::CrawlSetting.find_or_initialize_by(name: "画面確認用の収集")
setting.update!(
  enabled: false,
  search_keyword: "phone",
  platforms: ["mercari"],
  search_urls: [],
  required_keywords: [],
  negative_keywords: [],
  min_price: nil,
  max_price: nil
)

monitor = ProductMonitoring::Monitor.find_or_initialize_by(name: "画面確認用のモニタ")
monitor.update!(
  enabled: false,
  discord_enabled: false,
  newest_notification_enabled: false,
  required_keywords: ["phone"],
  negative_keywords: ["case"],
  min_price: 1_000,
  max_price: 50_000
)

# 名前に phone を含み case を含まないものだけがモニタに出る。価格は 1000〜50000。
rows = [
  { external_id: "on-sale-high", name: "phone 販売中・高額", price: 40_000, sold: false,
    recency_at: Time.zone.parse("2026-11-20 09:00:00") },
  { external_id: "on-sale-low", name: "phone 販売中・安価", price: 5_000, sold: false,
    recency_at: Time.zone.parse("2026-11-18 09:00:00") },
  { external_id: "on-sale-tie-early", name: "phone 販売中・同時刻の先", price: 8_000, sold: false,
    recency_at: Time.zone.parse("2026-11-15 09:00:00") },
  { external_id: "on-sale-tie-late", name: "phone 販売中・同時刻の後", price: 9_000, sold: false,
    recency_at: Time.zone.parse("2026-11-15 09:00:00") },
  { external_id: "sold-new", name: "phone 売り切れ・新しい", price: 18_000, sold: true,
    sold_at: Time.zone.parse("2026-11-10 09:00:00"), recency_at: Time.zone.parse("2026-11-10 09:00:00") },
  { external_id: "on-sale-oct", name: "phone 販売中・10月", price: 20_000, sold: false,
    recency_at: Time.zone.parse("2026-10-01 09:00:00") },
  { external_id: "on-sale-unknown", name: "phone 販売状態が不明", price: 11_000, sold: nil,
    recency_at: Time.zone.parse("2026-09-15 09:00:00") },
  { external_id: "on-sale-aug", name: "phone 販売中・8月", price: 15_000, sold: false,
    recency_at: Time.zone.parse("2026-08-01 09:00:00") },
  { external_id: "sold-jul", name: "phone 売り切れ・7月", price: 25_000, sold: true,
    sold_at: Time.zone.parse("2026-07-01 09:00:00"), recency_at: Time.zone.parse("2026-07-01 09:00:00") },
  { external_id: "on-sale-jun", name: "phone 販売中・6月", price: 12_000, sold: false,
    recency_at: Time.zone.parse("2026-06-01 09:00:00") },
  { external_id: "sold-old", name: "phone 売り切れ・古い", price: 7_000, sold: true,
    sold_at: Time.zone.parse("2026-01-15 09:00:00"), recency_at: Time.zone.parse("2026-01-15 09:00:00") },
  { external_id: "sold-undated", name: "phone 売り切れ・売れた日なし", price: 3_000, sold: true, recency_at: nil },
  { external_id: "miss-case", name: "phone case 対象外", price: 2_000, sold: false,
    recency_at: Time.zone.parse("2026-11-23 09:00:00") },
  { external_id: "miss-keyword", name: "tablet 対象外", price: 10_000, sold: false,
    recency_at: Time.zone.parse("2026-11-23 09:00:00") },
  { external_id: "miss-low", name: "phone 価格が下限未満", price: 500, sold: false,
    recency_at: Time.zone.parse("2026-11-23 09:00:00") },
  { external_id: "miss-high", name: "phone 価格が上限超え", price: 90_000, sold: false,
    recency_at: Time.zone.parse("2026-11-23 09:00:00") }
]

rows.each do |attrs|
  external_id = attrs.fetch(:external_id)
  result = setting.crawl_results.find_or_initialize_by(external_id:)
  result.update!(
    attrs.merge(
      platform: "iosys",
      product_url: "https://example.com/screen-check/#{external_id}",
      thumbnail_url: nil,
      buyout_price: nil,
      ends_at: nil,
      excluded_at: nil
    )
  )
end

excluded = setting.crawl_results.find_or_initialize_by(external_id: "excluded")
excluded.update!(
  platform: "iosys",
  name: "phone 除外済み",
  product_url: "https://example.com/screen-check/excluded",
  price: 4_000,
  sold: false,
  sold_at: nil,
  excluded_at: Time.zone.parse("2026-11-01 09:00:00"),
  recency_at: Time.zone.parse("2026-11-22 09:00:00")
)

warn("モニタリング設定の詳細: /product-monitoring/monitors/#{monitor.id}")
