# ヤフオククローリングの動作テスト用

ApplicationRecord.transaction do
  product = Product.create!(
    name: "M2 Macbook Air 15インチ"
  )

  YahooAuctionCrawlSetting.create!(
    product_id: product.id,
    enabled: true
  )
end
