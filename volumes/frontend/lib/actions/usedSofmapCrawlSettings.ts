'use server'

import * as Api from '@/lib/api'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export async function createUsedSofmapCrawlSettingExcludeProduct(
  productId: number,
  data: Api.CreateUsedSofmapCrawlSettingExcludeProductData,
) {
  const result = await Api.createUsedSofmapCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
