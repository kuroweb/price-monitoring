export type MercariCrawlSetting = {
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

export type MercariCrawlSettingExcludeKeyword = {
  id: number
  mercariCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type MercariCrawlSettingRequiredKeyword = {
  id: number
  mercariCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type MercariCrawlSettingExcludeProduct = {
  id: number
  mercariCrawlSettingId: number
  externalId: string
  createdAt: string
  updatedAt: string
}
