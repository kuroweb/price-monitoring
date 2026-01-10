import type { CreatePcKoubouCrawlSettingExcludeProductData } from './types'
import type { PcKoubouCrawlSettingExcludeProduct } from '../models'

import { http } from '@/lib/axios-client'

const basePath = (productId: number) =>
  `/api/v1/products/${productId}/pc_koubou_crawl_settings/pc_koubou_crawl_setting_exclude_products`

export async function createPcKoubouCrawlSettingExcludeProduct(
  productId: number,
  data: CreatePcKoubouCrawlSettingExcludeProductData,
) {
  return http<PcKoubouCrawlSettingExcludeProduct>(basePath(productId), {
    method: 'POST',
    data,
  })
}

export async function deletePcKoubouCrawlSettingExcludeProduct(productId: number, id: number) {
  return http(`${basePath(productId)}/${id}`, {
    method: 'DELETE',
  })
}
