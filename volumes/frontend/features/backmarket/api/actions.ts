'use server'

import { revalidatePaths } from '@/lib/revalidate-paths'

import * as RecentsApi from './backmarketRecents'
import * as Api from './backmarketWatchTargets'

import type { CreateBackmarketWatchTargetData, UpdateBackmarketWatchTargetData } from './types'


export async function getBackmarketWatchTargets() {
  return await Api.getBackmarketWatchTargets()
}

export async function createBackmarketWatchTarget(data: CreateBackmarketWatchTargetData) {
  const result = await Api.createBackmarketWatchTarget(data)
  revalidatePaths([['/admin/backmarket', 'page'], ['/backmarket', 'page']])
  return result
}

export async function updateBackmarketWatchTarget(
  backmarketWatchTargetId: number,
  data: UpdateBackmarketWatchTargetData,
) {
  const result = await Api.updateBackmarketWatchTarget(backmarketWatchTargetId, data)
  revalidatePaths([['/admin/backmarket', 'page'], ['/backmarket', 'page']])
  return result
}

export async function destroyBackmarketWatchTarget(backmarketWatchTargetId: number) {
  const result = await Api.destroyBackmarketWatchTarget(backmarketWatchTargetId)
  revalidatePaths([['/admin/backmarket', 'page'], ['/backmarket', 'page']])
  return result
}

export async function getBackmarketRecents() {
  return await RecentsApi.getBackmarketRecents()
}
