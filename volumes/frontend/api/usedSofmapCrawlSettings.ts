import type { UsedSofmapCrawlSettingExcludeProduct } from './models'

import { http } from '@/lib/axios-client'

const basePath = (productId: number) =>
  `/api/v1/products/${productId}/used_sofmap_crawl_settings/used_sofmap_crawl_setting_exclude_products`

export type CreateUsedSofmapCrawlSettingExcludeProductData = {
  externalId: string
}

export async function createUsedSofmapCrawlSettingExcludeProduct(
  productId: number,
  data: CreateUsedSofmapCrawlSettingExcludeProductData,
) {
  return http<UsedSofmapCrawlSettingExcludeProduct>(basePath(productId), {
    method: 'POST',
    data,
  })
}

export async function deleteUsedSofmapCrawlSettingExcludeProduct(productId: number, id: number) {
  return http(`${basePath(productId)}/${id}`, {
    method: 'DELETE',
  })
}
