import { http } from '@/lib/http-client'

import type {
  GetProductAggregationResults,
  GetProductAggregationSettings,
  ProductAggregationSetting,
  ProductAggregationSettingDraft,
} from './types'

const BASE_PATH = '/api/v1/product_aggregation_settings'

export const getProductAggregationSettings = () => http<GetProductAggregationSettings>(BASE_PATH)
export const getProductAggregationSetting = (id: number) =>
  http<ProductAggregationSetting>(`${BASE_PATH}/${id}`)
export const createProductAggregationSetting = (draft: ProductAggregationSettingDraft) =>
  http<ProductAggregationSetting>(BASE_PATH, { method: 'POST', data: draft })
export const updateProductAggregationSetting = (
  id: number,
  draft: ProductAggregationSettingDraft,
) => http<ProductAggregationSetting>(`${BASE_PATH}/${id}`, { method: 'PUT', data: draft })
export const destroyProductAggregationSetting = (id: number) =>
  http(`${BASE_PATH}/${id}`, { method: 'DELETE' })
export const calculateProductAggregationSetting = (id: number) =>
  http(`${BASE_PATH}/${id}/calculate`, { method: 'POST' })
export const getProductAggregationResults = (id: number) =>
  http<GetProductAggregationResults>(`${BASE_PATH}/${id}/product_aggregation_results`)
