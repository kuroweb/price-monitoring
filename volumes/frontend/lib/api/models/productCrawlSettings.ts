export type ProductCrawlSettingInput = {
  name: string
  enabled: boolean
  searchUrls: string[]
  requiredKeywords: string[]
  excludeKeywords: string[]
  minPrice: number | null
  maxPrice: number | null
}
export type ProductCrawlSetting = ProductCrawlSettingInput & { id: number }
// 「取得して保存」の結果。URLごとの取得状況と、取得した出品の採否
export type ProductCrawlSyncResult = {
  sources: {
    url: string
    platform: string | null
    status: 'succeeded' | 'failed' | 'unsupported'
    error: string | null
    fetchedCount: number
  }[]
  results: {
    platform: string
    externalId: string
    name: string
    price: number | null
    productUrl: string
    thumbnailUrl: string | null
    accepted: boolean
    reasons: string[]
  }[]
  fetchedCount: number
  acceptedCount: number
}
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
