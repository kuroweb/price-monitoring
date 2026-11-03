'use server'

import * as Api from '@/lib/api'
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
