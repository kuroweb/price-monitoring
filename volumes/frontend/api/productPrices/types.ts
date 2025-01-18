import type {
  Product,
  RelatedProduct,
  MercariDailyPurchaseSummary,
  YahooAuctionDailyPurchaseSummary,
  YahooFleamarketDailyPurchaseSummary,
} from '../models'

export type ProductPriceList = (Product & {
  relatedProducts: RelatedProduct[]
})[]

export type ProductPriceDetail = Product & {
  relatedProducts: RelatedProduct[]
  yahooAuctionDailyPurchaseSummaries: YahooAuctionDailyPurchaseSummary[]
  yahooFleamarketDailyPurchaseSummaries: YahooFleamarketDailyPurchaseSummary[]
  mercariDailyPurchaseSummaries: MercariDailyPurchaseSummary[]
}

export type GetProductPricesParams = {
  platformMask: string
  sort: string
  order: string
  priceDisplayLimit: number
}

export type GetProductPriceParams = {
  platformMask: string
  sort: string
  order: string
  page: number
  per: number
}
