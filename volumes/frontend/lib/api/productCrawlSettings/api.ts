import { http } from '@/lib/http-client'

import type {
  GetProductCrawlResults,
  GetProductCrawlSettings,
  ProductCrawlPreview,
  ProductCrawlSetting,
  ProductCrawlSettingDraft,
} from './types'

const BASE_PATH = '/api/v1/product_crawl_settings'

export const getProductCrawlSettings = () => http<GetProductCrawlSettings>(BASE_PATH)
export const getProductCrawlSetting = (id: number) =>
  http<ProductCrawlSetting>(`${BASE_PATH}/${id}`)
export const createProductCrawlSetting = (draft: ProductCrawlSettingDraft) =>
  http<ProductCrawlSetting>(BASE_PATH, { method: 'POST', data: draft })
export const updateProductCrawlSetting = (id: number, draft: ProductCrawlSettingDraft) =>
  http<ProductCrawlSetting>(`${BASE_PATH}/${id}`, { method: 'PUT', data: draft })
export const destroyProductCrawlSetting = (id: number) =>
  http(`${BASE_PATH}/${id}`, { method: 'DELETE' })
export const previewProductCrawlSetting = (draft: ProductCrawlSettingDraft) =>
  http<ProductCrawlPreview>(`${BASE_PATH}/preview`, { method: 'POST', data: draft })
export const syncProductCrawlSetting = (id: number) =>
  http<ProductCrawlPreview>(`${BASE_PATH}/${id}/sync`, { method: 'POST' })
export const getProductCrawlResults = (id: number) =>
  http<GetProductCrawlResults>(`${BASE_PATH}/${id}/product_crawl_results`)
export const excludeProductCrawlResult = (id: number, externalId: string) =>
  http<ProductCrawlSetting>(`${BASE_PATH}/${id}/exclude_external_ids`, {
    method: 'POST',
    data: { externalId },
  })
