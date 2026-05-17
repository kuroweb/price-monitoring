import type { BackmarketWatchResultList } from './types'

import { http } from '@/lib/http-client'

export async function getBackmarketWatchResults() {
  return http<BackmarketWatchResultList>('/api/v1/backmarket_watch_results', {
    method: 'GET',
  })
}
