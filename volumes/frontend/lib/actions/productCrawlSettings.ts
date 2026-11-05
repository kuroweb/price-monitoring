'use server'

import * as Api from '@/lib/api/productCrawlSettings'
import { revalidatePaths } from '@/lib/revalidate-paths'

const revalidate = () =>
  revalidatePaths([
    ['/admin/product-crawl-settings', 'page'],
    ['/product-crawl-results', 'layout'],
  ])

export async function getProductCrawlSettings() {
  return Api.getProductCrawlSettings()
}

export async function createProductCrawlSetting(input: Api.ProductCrawlSettingInput) {
  const result = await Api.createProductCrawlSetting(input)
  if (result.data) revalidate()
  return result
}

export async function updateProductCrawlSetting(id: number, input: Api.ProductCrawlSettingInput) {
  const result = await Api.updateProductCrawlSetting(id, input)
  if (result.data) revalidate()
  return result
}

export async function destroyProductCrawlSetting(id: number) {
  const result = await Api.destroyProductCrawlSetting(id)
  if (result.status === 200) revalidate()
  return result
}

export async function syncProductCrawlSetting(id: number) {
  const result = await Api.syncProductCrawlSetting(id)
  if (result.data) revalidate()
  return result
}

export async function setProductCrawlResultExcluded(id: number, excluded: boolean) {
  const result = await Api.setProductCrawlResultExcluded(id, excluded)
  if (result.data) revalidate()
  return result
}

export async function getProductCrawlSetting(id: number) {
  return Api.getProductCrawlSetting(id)
}

export async function getProductCrawlResults(params?: Api.GetProductCrawlResultsParams) {
  return Api.getProductCrawlResults(params)
}
