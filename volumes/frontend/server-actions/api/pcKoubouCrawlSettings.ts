'use server'

import * as Api from '@/api'
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

export async function deletePcKoubouCrawlSettingExcludeProduct(productId: number, id: number) {
  const result = await Api.deletePcKoubouCrawlSettingExcludeProduct(productId, id)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
