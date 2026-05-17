export type BackmarketRecent = {
  name: string
  price: number | null
  condition: string | null
  memory: string
  storage: string
  cpu: string
  stockStatus: string
  crawledAt: string
}

export type BackmarketRecentSection = {
  backmarketWatchTargetId: number
  watchName: string
  url: string
  results: BackmarketRecent[]
}

export type BackmarketRecentList = {
  backmarketRecentSections: BackmarketRecentSection[]
}
