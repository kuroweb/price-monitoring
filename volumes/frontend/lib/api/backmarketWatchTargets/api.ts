import type {
  BackmarketWatchTargetList,
  CreateBackmarketWatchTargetData,
  UpdateBackmarketWatchTargetData,
} from './types'
import type { BackmarketWatchTarget } from '../models'

import { http } from '@/lib/http-client'

export async function getBackmarketWatchTargets() {
  return http<BackmarketWatchTargetList>('/api/v1/backmarket_watch_targets', {
    method: 'GET',
  })
}

export async function createBackmarketWatchTarget(data: CreateBackmarketWatchTargetData) {
  return http<BackmarketWatchTarget>('/api/v1/backmarket_watch_targets', {
    method: 'POST',
    data,
  })
}

export async function updateBackmarketWatchTarget(
  backmarketWatchTargetId: number,
  data: UpdateBackmarketWatchTargetData,
) {
  return http<BackmarketWatchTarget>(`/api/v1/backmarket_watch_targets/${backmarketWatchTargetId}`, {
    method: 'PUT',
    data,
  })
}

export async function destroyBackmarketWatchTarget(backmarketWatchTargetId: number) {
  return http(`/api/v1/backmarket_watch_targets/${backmarketWatchTargetId}`, {
    method: 'DELETE',
  })
}
