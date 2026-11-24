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
export type ExtractionCriteria = {
  requiredKeywords: string[]
  negativeKeywords: string[]
  minPrice: number | null
  maxPrice: number | null
}
export type MonitorInput = ExtractionCriteria & {
  name: string
  enabled: boolean
  discordEnabled: boolean
  newestNotificationEnabled: boolean
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
export type MonitorSaleStatus = 'all' | 'on_sale' | 'sold'
export type MonitorCrawlResultSort = 'newest' | 'price_asc' | 'price_desc'
export type SearchCrawlResultsParams = ExtractionCriteria & {
  sort: MonitorCrawlResultSort
  page: number
}
export type SearchCrawlResultsPage = Required<GetMonitorCrawlResults>
export type GetMonitorCrawlResultsParams = {
  saleStatus?: MonitorSaleStatus
  sort?: MonitorCrawlResultSort
  page?: number
}
export type GetMonitorCrawlResults = {
  crawlResults: CrawlResult[]
  page?: number
  perPage?: number
  hasMore?: boolean
}
export type GetDailyMarketPrices = { dailyMarketPrices: DailyMarketPrice[] }
export type GetMonitorTransactions = { transactions: CrawlResult[] }
export type GetMonitorSummary = {
  lowestPrice: number | null
  latestAverageTransactionPrice: number | null
}
export type GetMonitorTransactionsParams = { startDate: string; endDate: string }
