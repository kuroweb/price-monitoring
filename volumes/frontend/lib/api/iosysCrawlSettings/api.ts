import type { CreateIosysCrawlSettingExcludeProductData } from './types'
import type { IosysCrawlSettingExcludeProduct } from '../models'

import { http } from '@/lib/axios-client'

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

export async function deleteIosysCrawlSettingExcludeProduct(productId: number, id: number) {
  return http(`${basePath(productId)}/${id}`, {
    method: 'DELETE',
  })
}
