export type CrawlSettingInput = {
  name: string
  enabled: boolean
  searchKeyword: string | null
  platforms: string[]
  searchUrls: string[]
  requiredKeywords: string[]
  negativeKeywords: string[]
  minPrice: number | null
  maxPrice: number | null
}
export type CrawlSetting = CrawlSettingInput & { id: number }
export type CrawlResult = {
  id: number
  crawlSettingId: number
  platform: string
  externalId: string
  name: string
  productUrl: string
  thumbnailUrl: string | null
  price: number
  buyoutPrice: number | null
  sold: boolean | null
  soldAt: string | null
  endsAt: string | null
  excludedAt: string | null
}
export type MonitorInput = {
  name: string
  enabled: boolean
  requiredKeywords: string[]
  negativeKeywords: string[]
  minPrice: number | null
  maxPrice: number | null
  discordEnabled: boolean
}
export type Monitor = MonitorInput & { id: number }
export type GetMonitors = {
  monitors: Monitor[]
  discordConfigured: boolean
}
export type DailyMarketPrice = {
  id: number
  monitorId: number
  date: string
  averageTransactionPrice: number | null
  transactionCount: number
}

export type GetCrawlSettings = { crawlSettings: CrawlSetting[] }
export type GetCrawlResults = {
  crawlResults: CrawlResult[]
  counts?: { crawlSettingId: number; sold: boolean | null; count: number }[]
}
export type GetCrawlResultsParams = { crawlSettingId?: number; excluded?: boolean }
export type GetDailyMarketPrices = { dailyMarketPrices: DailyMarketPrice[] }
export type GetMonitorTransactions = { transactions: CrawlResult[] }
export type GetMonitorTransactionsParams = { startDate: string; endDate: string }
