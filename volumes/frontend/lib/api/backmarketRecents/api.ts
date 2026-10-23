import { http } from '@/lib/http-client'

import type { BackmarketRecentList } from './types'

export async function getBackmarketRecents() {
  return http<BackmarketRecentList>('/api/v1/backmarket_recents', {
    method: 'GET',
  })
}
