export type UsedSofmapCrawlSetting = {
  id: number
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
  createdAt: string
  updatedAt: string
}

export type UsedSofmapCrawlSettingExcludeKeyword = {
  id: number
  usedSofmapCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type UsedSofmapCrawlSettingRequiredKeyword = {
  id: number
  usedSofmapCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type UsedSofmapCrawlSettingExcludeProduct = {
  id: number
  usedSofmapCrawlSettingId: number
  externalId: string
  createdAt: string
  updatedAt: string
}
