'use server'

import * as Api from '@/lib/api'

export async function getBackmarketRecents() {
  return await Api.getBackmarketRecents()
}
