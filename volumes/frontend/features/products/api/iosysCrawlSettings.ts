import { http } from '@/lib/http-client'

import type { CreateIosysCrawlSettingExcludeProductData } from './types'
import type { IosysCrawlSettingExcludeProduct } from './types'

const basePath = (productId: number) =>
  `/api/v1/products/${productId}/iosys_crawl_settings/iosys_crawl_setting_exclude_products`

export async function createIosysCrawlSettingExcludeProduct(
  productId: number,
  data: CreateIosysCrawlSettingExcludeProductData,
) {
  return http<IosysCrawlSettingExcludeProduct>(basePath(productId), {
    method: 'POST',
    data,
  })
}
