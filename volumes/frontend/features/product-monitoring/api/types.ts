export type ProductCrawlSettingInput = {
  name: string
  enabled: boolean
  keyword: string | null
  platforms: string[]
  searchUrls: string[]
  requiredKeywords: string[]
  excludeKeywords: string[]
  minPrice: number | null
  maxPrice: number | null
}
export type ProductCrawlSetting = ProductCrawlSettingInput & { id: number }
export type ProductCrawlResult = {
  id: number
  productCrawlSettingId: number
  platform: string
  externalId: string
  name: string
  productUrl: string
  thumbnailUrl: string | null
  price: number
  buyoutPrice: number | null
  sold: boolean | null
  boughtDate: string | null
  endDate: string | null
  excludedAt: string | null
}
export type ProductAggregationSettingInput = {
  name: string
  requiredKeywords: string[]
  excludeKeywords: string[]
  minPrice: number | null
  maxPrice: number | null
}
export type ProductAggregationSetting = ProductAggregationSettingInput & { id: number }
export type ProductAggregationResult = {
  id: number
  productAggregationSettingId: number
  date: string
  averagePurchasePrice: number | null
  purchaseCount: number
}

export type GetProductCrawlSettings = { productCrawlSettings: ProductCrawlSetting[] }
export type GetProductCrawlResults = {
  productCrawlResults: ProductCrawlResult[]
  counts?: { productCrawlSettingId: number; sold: boolean | null; count: number }[]
}
export type GetProductCrawlResultsParams = { productCrawlSettingId?: number; excluded?: boolean }
export type GetProductAggregationSettings = {
  productAggregationSettings: ProductAggregationSetting[]
}
export type GetProductAggregationResults = { productAggregationResults: ProductAggregationResult[] }
export type GetProductAggregationPurchases = { productCrawlResults: ProductCrawlResult[] }
export type GetProductAggregationPurchasesParams = { startDate: string; endDate: string }
