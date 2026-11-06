import { http } from '@/lib/http-client'

import type {
  GetProductCrawlResults,
  GetProductCrawlResultsParams,
  GetProductCrawlSettings,
  ProductCrawlResult,
  ProductCrawlSetting,
  ProductCrawlSettingInput,
  ProductCrawlSyncResult,
} from './types'

const BASE_PATH = '/api/v1/product_crawl_settings'
const RESULTS_PATH = '/api/v1/product_crawl_results'

export const getProductCrawlSettings = () => http<GetProductCrawlSettings>(BASE_PATH)
export const getProductCrawlSetting = (id: number) =>
  http<ProductCrawlSetting>(`${BASE_PATH}/${id}`)
export const createProductCrawlSetting = (input: ProductCrawlSettingInput) =>
  http<ProductCrawlSetting>(BASE_PATH, { method: 'POST', data: input })
export const updateProductCrawlSetting = (id: number, input: ProductCrawlSettingInput) =>
  http<ProductCrawlSetting>(`${BASE_PATH}/${id}`, { method: 'PUT', data: input })
export const destroyProductCrawlSetting = (id: number) =>
  http(`${BASE_PATH}/${id}`, { method: 'DELETE' })
export const syncProductCrawlSetting = (id: number) =>
  http<ProductCrawlSyncResult>(`${BASE_PATH}/${id}/sync`, { method: 'POST' })
export const getProductCrawlResults = (params?: GetProductCrawlResultsParams) =>
  http<GetProductCrawlResults>(RESULTS_PATH, { params })
// 除外と取り消し。行は消さず excluded_at で表す
export const setProductCrawlResultExcluded = (id: number, excluded: boolean) =>
  http<ProductCrawlResult>(`${RESULTS_PATH}/${id}`, { method: 'PATCH', data: { excluded } })
