'use server'

import * as Api from '@/api'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export async function createJanparaCrawlSettingExcludeProduct(
  productId: number,
  data: Api.CreateJanparaCrawlSettingExcludeProductData,
) {
  const result = await Api.createJanparaCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function deleteJanparaCrawlSettingExcludeProduct(productId: number, id: number) {
  const result = await Api.deleteJanparaCrawlSettingExcludeProduct(productId, id)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
