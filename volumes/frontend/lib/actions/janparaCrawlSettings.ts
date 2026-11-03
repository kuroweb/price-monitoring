'use server'

import * as Api from '@/lib/api'
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
