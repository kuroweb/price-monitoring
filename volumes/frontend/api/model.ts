export type Product = {
  id: number
  name: string
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

export type Category = {
  id: number
  parentId: number | null
  name: string
  createdAt: string
  updatedAt: string
}
