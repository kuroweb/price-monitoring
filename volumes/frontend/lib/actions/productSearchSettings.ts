'use server'

import * as Api from '@/lib/api/productSearchSettings'
import { revalidatePaths } from '@/lib/revalidate-paths'

export async function getProductSearchSettings() {
  return Api.getProductSearchSettings()
}

export async function previewProductSearchSetting(draft: Api.ProductSearchDraft) {
  return Api.previewProductSearchSetting(draft)
}

export async function createProductSearchSetting(draft: Api.ProductSearchDraft) {
  const result = await Api.createProductSearchSetting(draft)
  if (result.data) revalidatePaths([['/admin/products/search-settings', 'page']])
  return result
}

export async function updateProductSearchSetting(id: number, draft: Api.ProductSearchDraft) {
  const result = await Api.updateProductSearchSetting(id, draft)
  if (result.data) revalidatePaths([['/admin/products/search-settings', 'page']])
  return result
}

export async function deleteProductSearchSetting(id: number) {
  const result = await Api.deleteProductSearchSetting(id)
  if (result.status === 200) revalidatePaths([['/admin/products/search-settings', 'page']])
  return result
}
