'use server'

import * as Api from '@/lib/api/productAggregationSettings'
import { revalidatePaths } from '@/lib/revalidate-paths'

const revalidate = () =>
  revalidatePaths([
    ['/admin/product-aggregation-settings', 'page'],
    ['/product-aggregation-results', 'page'],
  ])

export async function getProductAggregationSettings() {
  return Api.getProductAggregationSettings()
}

export async function createProductAggregationSetting(input: Api.ProductAggregationSettingInput) {
  const result = await Api.createProductAggregationSetting(input)
  if (result.data) revalidate()
  return result
}

export async function updateProductAggregationSetting(
  id: number,
  input: Api.ProductAggregationSettingInput,
) {
  const result = await Api.updateProductAggregationSetting(id, input)
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

export async function getAllProductAggregationResults() {
  return Api.getAllProductAggregationResults()
}
