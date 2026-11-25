import type { Category } from '@/lib/category'

export type YahooAuctionDailyPurchaseSummary = {
  id: number
  productId: number
  averagePurchasePrice: number
  purchaseCount: number
  date: string
  createdAt: string
  updatedAt: string
}

export type YahooFleamarketDailyPurchaseSummary = {
  id: number
  productId: number
  averagePurchasePrice: number
  purchaseCount: number
  date: string
  createdAt: string
  updatedAt: string
}

export type Product = {
  id: number
  name: string
  createdAt: string
  updatedAt: string
}

export type RelatedProduct = {
  platform: string
  productId: number
  externalId: string
  name: string
  price: number
  buyoutPrice: number | null
  thumbnailUrl: string
  published: boolean
  boughtDate: string
  endDate: string
  createdAt: string
  updatedAt: string
}

export type YahooAuctionCrawlSetting = {
  id: number
  productId: number
  keyword: string
  categoryId: number | null
  minPrice: number
  maxPrice: number
  enabled: boolean
  createdAt: string
  updatedAt: string
}

export type YahooAuctionCrawlSettingExcludeKeyword = {
  id: number
  yahooAuctionCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type YahooAuctionCrawlSettingRequiredKeyword = {
  id: number
  yahooAuctionCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type YahooAuctionCrawlSettingExcludeProduct = {
  id: number
  yahooAuctionCrawlSettingId: number
  externalId: string
  createdAt: string
  updatedAt: string
}

export type ProductPriceList = (Product & {
  relatedProducts: RelatedProduct[]
})[]

export type ProductPriceDetail = Product & {
  relatedProducts: RelatedProduct[]
  yahooAuctionDailyPurchaseSummaries: YahooAuctionDailyPurchaseSummary[]
  yahooFleamarketDailyPurchaseSummaries: YahooFleamarketDailyPurchaseSummary[]
}

export type GetProductPricesParams = {
  categoryId: number | null
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

export type ProductDetail = Product & {
  yahooAuctionCrawlSetting: YahooAuctionCrawlSetting & {
    yahooAuctionCrawlSettingExcludeKeywords: YahooAuctionCrawlSettingExcludeKeyword[]
    yahooAuctionCrawlSettingRequiredKeywords: YahooAuctionCrawlSettingRequiredKeyword[]
  }
  category: Category
  yahoo_auction_daily_purchase_summaries: YahooAuctionDailyPurchaseSummary[]
  yahoo_fleamarket_daily_purchase_summaries: YahooFleamarketDailyPurchaseSummary[]
}

export type ProductList = {
  products: (Product & {
    yahooAuctionCrawlSetting: YahooAuctionCrawlSetting & {
      yahooAuctionCrawlSettingExcludeKeywords: YahooAuctionCrawlSettingExcludeKeyword[]
      yahooAuctionCrawlSettingRequiredKeywords: YahooAuctionCrawlSettingRequiredKeyword[]
    }
    category: Category
  })[]
}

// TODO: 後で実装する
export type GetProductsParams = Record<string, never>

export type CreateProductData = {
  name: string
  categoryId: number | null
  yahooAuctionCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    yahooAuctionCrawlSettingExcludeKeywords: { keyword: string }[]
    yahooAuctionCrawlSettingRequiredKeywords: { keyword: string }[]
  }
}

export type UpdateProductData = CreateProductData

export type CreateYahooAuctionCrawlSettingExcludeProductData = {
  externalId: string
}

