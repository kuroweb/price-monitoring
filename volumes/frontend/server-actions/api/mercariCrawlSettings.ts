'use server'

import * as Api from '@/api'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export async function createMercariCrawlSettingExcludeProduct(
  productId: number,
  data: Api.CreateMercariCrawlSettingExcludeProductData,
) {
  const result = await Api.createMercariCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function deleteMercariCrawlSettingExcludeProduct(productId: number, id: number) {
  const result = await Api.deleteMercariCrawlSettingExcludeProduct(productId, id)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
