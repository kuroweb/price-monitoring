import type { MercariCrawlSettingExcludeProduct } from './model'

import { http } from '@/lib/axios-client'

const basePath = (productId: number) =>
  `/api/v1/products/${productId}/mercari_crawl_settings/mercari_crawl_setting_exclude_products`

export type CreateMercariCrawlSettingExcludeProductData = {
  externalId: string
}

export async function createMercariCrawlSettingExcludeProduct(
  productId: number,
  data: CreateMercariCrawlSettingExcludeProductData,
) {
  return http<MercariCrawlSettingExcludeProduct>(basePath(productId), {
    method: 'POST',
    data,
  })
}

export async function deleteMercariCrawlSettingExcludeProduct(productId: number, id: number) {
  return http(`${basePath(productId)}/${id}`, {
    method: 'DELETE',
  })
}
