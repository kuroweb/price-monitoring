'use server'

import * as Api from '@/lib/api'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export async function createYahooAuctionCrawlSettingExcludeProduct(
  productId: number,
  data: Api.CreateYahooAuctionCrawlSettingExcludeProductData,
) {
  const result = await Api.createYahooAuctionCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
