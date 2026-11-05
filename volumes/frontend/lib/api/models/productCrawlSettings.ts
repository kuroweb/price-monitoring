export type ProductCrawlSettingDraft = {
  name: string
  enabled: boolean
  searchUrls: string[]
  requiredKeywords: string[]
  excludeKeywords: string[]
  excludeExternalIds: string[]
  minPrice: number | null
  maxPrice: number | null
}
export type ProductCrawlSetting = ProductCrawlSettingDraft & { id: number }
export type ProductCrawlPreview = {
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
}
