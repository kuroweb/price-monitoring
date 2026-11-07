import { http } from '@/lib/http-client'

import type { CreateJanparaCrawlSettingExcludeProductData } from './types'
import type { JanparaCrawlSettingExcludeProduct } from './types'

const basePath = (productId: number) =>
  `/api/v1/products/${productId}/janpara_crawl_settings/janpara_crawl_setting_exclude_products`

export async function createJanparaCrawlSettingExcludeProduct(
  productId: number,
  data: CreateJanparaCrawlSettingExcludeProductData,
) {
  return http<JanparaCrawlSettingExcludeProduct>(basePath(productId), {
    method: 'POST',
    data,
  })
}
