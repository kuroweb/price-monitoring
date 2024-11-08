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

export type Category = {
  id: number
  parentId: number | null
  name: string
  createdAt: string
  updatedAt: string
}
