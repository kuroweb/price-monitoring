export type BackmarketWatchResult = {
  backmarketWatchTargetId: number
  watchName: string
  url: string
  name: string
  price: number | null
  condition: string | null
  memory: string
  storage: string
  cpu: string
  stockStatus: string
  crawledAt: string
}

export type BackmarketWatchResultList = {
  backmarketWatchResults: BackmarketWatchResult[]
}
