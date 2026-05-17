'use server'

import * as Api from '@/lib/api'

export async function getBackmarketWatchResults() {
  return await Api.getBackmarketWatchResults()
}
