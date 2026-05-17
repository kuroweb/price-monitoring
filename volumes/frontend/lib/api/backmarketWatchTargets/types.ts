import type { BackmarketWatchTarget } from '../models'

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
