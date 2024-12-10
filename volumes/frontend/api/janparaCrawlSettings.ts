import type { JanparaCrawlSettingExcludeProduct } from './models'

import { http } from '@/lib/axios-client'

const basePath = (productId: number) =>
  `/api/v1/products/${productId}/janpara_crawl_settings/janpara_crawl_setting_exclude_products`

export type CreateJanparaCrawlSettingExcludeProductData = {
  externalId: string
}

export async function createJanparaCrawlSettingExcludeProduct(
  productId: number,
  data: CreateJanparaCrawlSettingExcludeProductData,
) {
  return http<JanparaCrawlSettingExcludeProduct>(basePath(productId), {
    method: 'POST',
    data,
  })
}

export async function deleteJanparaCrawlSettingExcludeProduct(productId: number, id: number) {
  return http(`${basePath(productId)}/${id}`, {
    method: 'DELETE',
  })
}
