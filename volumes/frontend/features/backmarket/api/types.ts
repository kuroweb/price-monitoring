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
export type BackmarketWatchTarget = {
  id: number
  name: string
  url: string
  enabled: boolean
  createdAt: string
  updatedAt: string
}
export type BackmarketWatchTargetList = {
  backmarketWatchTargets: BackmarketWatchTarget[]
}

export type CreateBackmarketWatchTargetData = {
  name: string
  url: string
  enabled: boolean
}

export type UpdateBackmarketWatchTargetData = {
  name: string
  url: string
  enabled: boolean
}
