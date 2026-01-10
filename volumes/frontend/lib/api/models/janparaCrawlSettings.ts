export type JanparaCrawlSetting = {
  id: number
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
  createdAt: string
  updatedAt: string
}

export type JanparaCrawlSettingExcludeKeyword = {
  id: number
  janparaCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type JanparaCrawlSettingRequiredKeyword = {
  id: number
  janparaCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type JanparaCrawlSettingExcludeProduct = {
  id: number
  janparaCrawlSettingId: number
  externalId: string
  createdAt: string
  updatedAt: string
}
