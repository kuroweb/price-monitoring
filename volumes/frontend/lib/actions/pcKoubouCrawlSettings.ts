'use server'

import * as Api from '@/lib/api'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export async function createPcKoubouCrawlSettingExcludeProduct(
  productId: number,
  data: Api.CreatePcKoubouCrawlSettingExcludeProductData,
) {
  const result = await Api.createPcKoubouCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
