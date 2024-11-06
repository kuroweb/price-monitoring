export type Product = {
  id: number
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
  id: number
  productId: number
  keyword: string
  categoryId: number | null
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type MercariCrawlSetting = {
  id: number
  productId: number
  keyword: string
  categoryId: number | null
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type JanparaCrawlSetting = {
  id: number
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type IosysCrawlSetting = {
  id: number
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type PcKoubouCrawlSetting = {
  id: number
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type UsedSofmapCrawlSetting = {
  id: number
  productId: number
  keyword: string
  minPrice: number
  maxPrice: number
  enabled: boolean
}

export type Category = {
  id: number
  parentId: number | null
  name: string
}
