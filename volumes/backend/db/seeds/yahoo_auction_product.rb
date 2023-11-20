# ヤフオククローリングの動作テスト用

ApplicationRecord.transaction do
  product = Product.create!(
    name: "M2 Macbook Air 15インチ"
  )

  YahooAuctionCrawlSetting.create!(
    product_id: product.id,
    category_id: 2_084_286_828,
    enabled: true
  )

  product = Product.create!(
    name: "M1 Macbook Air"
  )

  YahooAuctionCrawlSetting.create!(
    product_id: product.id,
    category_id: 2_084_286_828,
    enabled: true
  )
end
