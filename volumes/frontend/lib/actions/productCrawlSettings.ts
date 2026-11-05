'use server'

import * as Api from '@/lib/api/productCrawlSettings'
import { revalidatePaths } from '@/lib/revalidate-paths'

const revalidate = () => revalidatePaths([['/admin/product-crawl-settings', 'layout']])

export async function getProductCrawlSettings() {
  return Api.getProductCrawlSettings()
}

export async function getProductCrawlSetting(id: number) {
  return Api.getProductCrawlSetting(id)
}

export async function previewProductCrawlSetting(draft: Api.ProductCrawlSettingDraft) {
  return Api.previewProductCrawlSetting(draft)
}

export async function createProductCrawlSetting(draft: Api.ProductCrawlSettingDraft) {
  const result = await Api.createProductCrawlSetting(draft)
  if (result.data) revalidate()
  return result
}

export async function updateProductCrawlSetting(id: number, draft: Api.ProductCrawlSettingDraft) {
  const result = await Api.updateProductCrawlSetting(id, draft)
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

export async function getProductCrawlResults(id: number) {
  return Api.getProductCrawlResults(id)
}

export async function excludeProductCrawlResult(id: number, externalId: string) {
  const result = await Api.excludeProductCrawlResult(id, externalId)
  if (result.data) revalidate()
  return result
}
