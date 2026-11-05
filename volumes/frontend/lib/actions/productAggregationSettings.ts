'use server'

import * as Api from '@/lib/api/productAggregationSettings'
import { revalidatePaths } from '@/lib/revalidate-paths'

const revalidate = () => revalidatePaths([['/admin/product-aggregation-settings', 'layout']])

export async function getProductAggregationSettings() {
  return Api.getProductAggregationSettings()
}

export async function getProductAggregationSetting(id: number) {
  return Api.getProductAggregationSetting(id)
}

export async function createProductAggregationSetting(draft: Api.ProductAggregationSettingDraft) {
  const result = await Api.createProductAggregationSetting(draft)
  if (result.data) revalidate()
  return result
}

export async function updateProductAggregationSetting(
  id: number,
  draft: Api.ProductAggregationSettingDraft,
) {
  const result = await Api.updateProductAggregationSetting(id, draft)
  if (result.data) revalidate()
  return result
}

export async function destroyProductAggregationSetting(id: number) {
  const result = await Api.destroyProductAggregationSetting(id)
  if (result.status === 200) revalidate()
  return result
}

export async function calculateProductAggregationSetting(id: number) {
  const result = await Api.calculateProductAggregationSetting(id)
  if (result.status === 200) revalidate()
  return result
}

export async function getProductAggregationResults(id: number) {
  return Api.getProductAggregationResults(id)
}
