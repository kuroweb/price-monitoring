export type PcKoubouCrawlSetting = {
  id: number
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
  createdAt: string
  updatedAt: string
}

export type PcKoubouCrawlSettingExcludeKeyword = {
  id: number
  pcKoubouCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type PcKoubouCrawlSettingRequiredKeyword = {
  id: number
  pcKoubouCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type PcKoubouCrawlSettingExcludeProduct = {
  id: number
  pcKoubouCrawlSettingId: number
  externalId: string
  createdAt: string
  updatedAt: string
}
