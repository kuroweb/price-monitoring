'use server'

import * as Api from '@/api'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export async function createIosysCrawlSettingExcludeProduct(
  productId: number,
  data: Api.CreateIosysCrawlSettingExcludeProductData,
) {
  const result = await Api.createIosysCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function deleteIosysCrawlSettingExcludeProduct(productId: number, id: number) {
  const result = await Api.deleteIosysCrawlSettingExcludeProduct(productId, id)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
