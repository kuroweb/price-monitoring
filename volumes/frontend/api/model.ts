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
  yahooAuctionCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type MercariCrawlSettingRequiredKeyword = {
  id: number
  yahooAuctionCrawlSettingId: number
  keyword: string
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
  yahooAuctionCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type JanparaCrawlSettingRequiredKeyword = {
  id: number
  yahooAuctionCrawlSettingId: number
  keyword: string
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
  yahooAuctionCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type IosysCrawlSettingRequiredKeyword = {
  id: number
  yahooAuctionCrawlSettingId: number
  keyword: string
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
  yahooAuctionCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type PcKoubouCrawlSettingRequiredKeyword = {
  id: number
  yahooAuctionCrawlSettingId: number
  keyword: string
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
  yahooAuctionCrawlSettingId: number
  keyword: string
  createdAt: string
  updatedAt: string
}

export type UsedSofmapCrawlSettingRequiredKeyword = {
  id: number
  yahooAuctionCrawlSettingId: number
  keyword: string
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
