import type { Category } from '@/lib/category'

export type CreateIosysCrawlSettingExcludeProductData = {
  externalId: string
}

export type CreateJanparaCrawlSettingExcludeProductData = {
  externalId: string
}

export type CreateMercariCrawlSettingExcludeProductData = {
  externalId: string
}

export type YahooAuctionDailyPurchaseSummary = {
  id: number
  productId: number
  averagePurchasePrice: number
  purchaseCount: number
  date: string
  createdAt: string
  updatedAt: string
}

export type YahooFleamarketDailyPurchaseSummary = {
  id: number
  productId: number
  averagePurchasePrice: number
  purchaseCount: number
  date: string
  createdAt: string
  updatedAt: string
}

export type MercariDailyPurchaseSummary = {
  id: number
  productId: number
  averagePurchasePrice: number
  purchaseCount: number
  date: string
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

export type Product = {
  id: number
  name: string
  createdAt: string
  updatedAt: string
}

export type RelatedProduct = {
  platform: string
  productId: number
  externalId: string
  name: string
  price: number
  buyoutPrice: number | null
  thumbnailUrl: string
  published: boolean
  boughtDate: string
  endDate: string
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

export type CreatePcKoubouCrawlSettingExcludeProductData = {
  externalId: string
}

export type ProductPriceList = (Product & {
  relatedProducts: RelatedProduct[]
})[]

export type ProductPriceDetail = Product & {
  relatedProducts: RelatedProduct[]
  yahooAuctionDailyPurchaseSummaries: YahooAuctionDailyPurchaseSummary[]
  yahooFleamarketDailyPurchaseSummaries: YahooFleamarketDailyPurchaseSummary[]
  mercariDailyPurchaseSummaries: MercariDailyPurchaseSummary[]
}

export type GetProductPricesParams = {
  categoryId: number | null
  platformMask: string
  sort: string
  order: string
  priceDisplayLimit: number
}

export type GetProductPriceParams = {
  platformMask: string
  sort: string
  order: string
  page: number
  per: number
}

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

// TODO: 後で実装する
export type GetProductsParams = Record<string, never>

export type CreateProductData = {
  name: string
  categoryId: number | null
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

export type UpdateProductData = CreateProductData

export type CreateUsedSofmapCrawlSettingExcludeProductData = {
  externalId: string
}

export type CreateYahooAuctionCrawlSettingExcludeProductData = {
  externalId: string
}

