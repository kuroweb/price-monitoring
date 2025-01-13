import type {
  Category,
  IosysCrawlSetting,
  IosysCrawlSettingExcludeKeyword,
  IosysCrawlSettingRequiredKeyword,
  JanparaCrawlSetting,
  JanparaCrawlSettingExcludeKeyword,
  JanparaCrawlSettingRequiredKeyword,
  MercariCrawlSetting,
  MercariCrawlSettingExcludeKeyword,
  MercariCrawlSettingRequiredKeyword,
  MercariDailyPurchaseSummary,
  PcKoubouCrawlSetting,
  PcKoubouCrawlSettingExcludeKeyword,
  PcKoubouCrawlSettingRequiredKeyword,
  Product,
  UsedSofmapCrawlSetting,
  UsedSofmapCrawlSettingExcludeKeyword,
  UsedSofmapCrawlSettingRequiredKeyword,
  YahooAuctionCrawlSetting,
  YahooAuctionCrawlSettingExcludeKeyword,
  YahooAuctionCrawlSettingRequiredKeyword,
  YahooAuctionDailyPurchaseSummary,
  YahooFleamarketDailyPurchaseSummary,
} from '../models'

export type ProductDetail = Product & {
  yahooAuctionCrawlSetting: YahooAuctionCrawlSetting & {
    yahooAuctionCrawlSettingExcludeKeywords: YahooAuctionCrawlSettingExcludeKeyword[]
    yahooAuctionCrawlSettingRequiredKeywords: YahooAuctionCrawlSettingRequiredKeyword[]
  }
  mercariCrawlSetting: MercariCrawlSetting & {
    mercariCrawlSettingExcludeKeywords: MercariCrawlSettingExcludeKeyword[]
    mercariCrawlSettingRequiredKeywords: MercariCrawlSettingRequiredKeyword[]
  }
  iosysCrawlSetting: IosysCrawlSetting & {
    iosysCrawlSettingExcludeKeywords: IosysCrawlSettingExcludeKeyword[]
    iosysCrawlSettingRequiredKeywords: IosysCrawlSettingRequiredKeyword[]
  }
  janparaCrawlSetting: JanparaCrawlSetting & {
    janparaCrawlSettingExcludeKeywords: JanparaCrawlSettingExcludeKeyword[]
    janparaCrawlSettingRequiredKeywords: JanparaCrawlSettingRequiredKeyword[]
  }
  pcKoubouCrawlSetting: PcKoubouCrawlSetting & {
    pcKoubouCrawlSettingExcludeKeywords: PcKoubouCrawlSettingExcludeKeyword[]
    pcKoubouCrawlSettingRequiredKeywords: PcKoubouCrawlSettingRequiredKeyword[]
  }
  usedSofmapCrawlSetting: UsedSofmapCrawlSetting & {
    usedSofmapCrawlSettingExcludeKeywords: UsedSofmapCrawlSettingExcludeKeyword[]
    usedSofmapCrawlSettingRequiredKeywords: UsedSofmapCrawlSettingRequiredKeyword[]
  }
  category: Category
  yahoo_auction_daily_purchase_summaries: YahooAuctionDailyPurchaseSummary[]
  yahoo_fleamarket_daily_purchase_summaries: YahooFleamarketDailyPurchaseSummary[]
  mercari_daily_purchase_summaries: MercariDailyPurchaseSummary[]
}

export type ProductList = {
  products: (Product & {
    yahooAuctionCrawlSetting: YahooAuctionCrawlSetting & {
      yahooAuctionCrawlSettingExcludeKeywords: YahooAuctionCrawlSettingExcludeKeyword[]
      yahooAuctionCrawlSettingRequiredKeywords: YahooAuctionCrawlSettingRequiredKeyword[]
    }
    mercariCrawlSetting: MercariCrawlSetting & {
      mercariCrawlSettingExcludeKeywords: MercariCrawlSettingExcludeKeyword[]
      mercariCrawlSettingRequiredKeywords: MercariCrawlSettingRequiredKeyword[]
    }
    iosysCrawlSetting: IosysCrawlSetting & {
      iosysCrawlSettingExcludeKeywords: IosysCrawlSettingExcludeKeyword[]
      iosysCrawlSettingRequiredKeywords: IosysCrawlSettingRequiredKeyword[]
    }
    janparaCrawlSetting: JanparaCrawlSetting & {
      janparaCrawlSettingExcludeKeywords: JanparaCrawlSettingExcludeKeyword[]
      janparaCrawlSettingRequiredKeywords: JanparaCrawlSettingRequiredKeyword[]
    }
    pcKoubouCrawlSetting: PcKoubouCrawlSetting & {
      pcKoubouCrawlSettingExcludeKeywords: PcKoubouCrawlSettingExcludeKeyword[]
      pcKoubouCrawlSettingRequiredKeywords: PcKoubouCrawlSettingRequiredKeyword[]
    }
    usedSofmapCrawlSetting: UsedSofmapCrawlSetting & {
      usedSofmapCrawlSettingExcludeKeywords: UsedSofmapCrawlSettingExcludeKeyword[]
      usedSofmapCrawlSettingRequiredKeywords: UsedSofmapCrawlSettingRequiredKeyword[]
    }
    category: Category
  })[]
}

export type GetProductsParams = {
  // TODO: 後で実装する
}

export type CreateProductData = {
  name: string
  categoryId: number
  yahooAuctionCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    yahooAuctionCrawlSettingExcludeKeywords: { keyword: string }[]
    yahooAuctionCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  mercariCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    mercariCrawlSettingExcludeKeywords: { keyword: string }[]
    mercariCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  iosysCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    iosysCrawlSettingExcludeKeywords: { keyword: string }[]
    iosysCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  janparaCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    janparaCrawlSettingExcludeKeywords: { keyword: string }[]
    janparaCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  pcKoubouCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    pcKoubouCrawlSettingExcludeKeywords: { keyword: string }[]
    pcKoubouCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  usedSofmapCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    usedSofmapCrawlSettingExcludeKeywords: { keyword: string }[]
    usedSofmapCrawlSettingRequiredKeywords: { keyword: string }[]
  }
}

export type UpdateProductData = {
  name: string
  categoryId: number
  yahooAuctionCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    yahooAuctionCrawlSettingExcludeKeywords: { keyword: string }[]
    yahooAuctionCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  mercariCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    mercariCrawlSettingExcludeKeywords: { keyword: string }[]
    mercariCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  iosysCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    iosysCrawlSettingExcludeKeywords: { keyword: string }[]
    iosysCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  janparaCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    janparaCrawlSettingExcludeKeywords: { keyword: string }[]
    janparaCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  pcKoubouCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    pcKoubouCrawlSettingExcludeKeywords: { keyword: string }[]
    pcKoubouCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  usedSofmapCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    usedSofmapCrawlSettingExcludeKeywords: { keyword: string }[]
    usedSofmapCrawlSettingRequiredKeywords: { keyword: string }[]
  }
}
