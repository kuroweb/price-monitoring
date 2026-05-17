'use server'

import * as Api from '@/lib/api'
import { revalidatePaths } from '@/lib/revalidate-paths'

export async function getBackmarketWatchTargets() {
  return await Api.getBackmarketWatchTargets()
}

export async function createBackmarketWatchTarget(data: Api.CreateBackmarketWatchTargetData) {
  const result = await Api.createBackmarketWatchTarget(data)
  revalidatePaths([['/admin/backmarket_watch', 'page']])
  return result
}

export async function updateBackmarketWatchTarget(
  backmarketWatchTargetId: number,
  data: Api.UpdateBackmarketWatchTargetData,
) {
  const result = await Api.updateBackmarketWatchTarget(backmarketWatchTargetId, data)
  revalidatePaths([['/admin/backmarket_watch', 'page']])
  return result
}

export async function destroyBackmarketWatchTarget(backmarketWatchTargetId: number) {
  const result = await Api.destroyBackmarketWatchTarget(backmarketWatchTargetId)
  revalidatePaths([['/admin/backmarket_watch', 'page']])
  return result
}
