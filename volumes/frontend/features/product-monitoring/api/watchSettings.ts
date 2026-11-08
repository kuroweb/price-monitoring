import { http } from '@/lib/http-client'

import type {
  GetProductCrawlResults,
  GetProductWatchSettings,
  ProductWatchSetting,
  ProductWatchSettingInput,
} from './types'

const BASE_PATH = '/api/v1/product_watch_settings'

export const getProductWatchSettings = () => http<GetProductWatchSettings>(BASE_PATH)
export const getProductWatchResults = (id: number) =>
  http<GetProductCrawlResults>(`${BASE_PATH}/${id}/results`)
export const createProductWatchSetting = (input: ProductWatchSettingInput) =>
  http<ProductWatchSetting>(BASE_PATH, { method: 'POST', data: input })
export const updateProductWatchSetting = (id: number, input: ProductWatchSettingInput) =>
  http<ProductWatchSetting>(`${BASE_PATH}/${id}`, { method: 'PUT', data: input })
export const destroyProductWatchSetting = (id: number) =>
  http(`${BASE_PATH}/${id}`, { method: 'DELETE' })
