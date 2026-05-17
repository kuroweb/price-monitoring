import type { BackmarketRecentList } from './types'

import { http } from '@/lib/http-client'

export async function getBackmarketRecents() {
  return http<BackmarketRecentList>('/api/v1/backmarket_recents', {
    method: 'GET',
  })
}
