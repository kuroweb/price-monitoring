export type IosysCrawlSetting = {
  id: number
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
  createdAt: string
  updatedAt: string
}

export type IosysCrawlSettingExcludeKeyword = {
  id: number
  iosysCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type IosysCrawlSettingRequiredKeyword = {
  id: number
  iosysCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type IosysCrawlSettingExcludeProduct = {
  id: number
  iosysCrawlSettingId: number
  externalId: string
  createdAt: string
  updatedAt: string
}
