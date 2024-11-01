export type Product = {
  id: string
  name: string
  createdAt: string
  updatedAt: string
  iosysCrawlSetting: IosysCrawlSetting
  janparaCrawlSetting: JanparaCrawlSetting
  mercariCrawlSetting: MercariCrawlSetting
  pcKoubouCrawlSetting: PcKoubouCrawlSetting
  usedSofmapCrawlSetting: UsedSofmapCrawlSetting
  yahooAuctionCrawlSetting: YahooAuctionCrawlSetting
  category: Category
}

export type YahooAuctionCrawlSetting = {
  id: string
  productId: number
  keyword: string
  categoryId?: number | null
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type MercariCrawlSetting = {
  id: string
  productId: number
  keyword: string
  categoryId?: number | null
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type JanparaCrawlSetting = {
  id: string
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type IosysCrawlSetting = {
  id: string
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type PcKoubouCrawlSetting = {
  id: string
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type UsedSofmapCrawlSetting = {
  id: string
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type Category = {
  id: string
  parentId?: string | null
  name: string
}
