import { http } from '@/lib/http-client'

import type {
  GetProductAggregationPurchases,
  GetProductAggregationPurchasesParams,
  GetProductAggregationResults,
  GetProductAggregationSettings,
  ProductAggregationSetting,
  ProductAggregationSettingInput,
} from './types'

const BASE_PATH = '/api/v1/product_aggregation_settings'

export const getProductAggregationSettings = () => http<GetProductAggregationSettings>(BASE_PATH)
export const createProductAggregationSetting = (input: ProductAggregationSettingInput) =>
  http<ProductAggregationSetting>(BASE_PATH, { method: 'POST', data: input })
export const updateProductAggregationSetting = (
  id: number,
  input: ProductAggregationSettingInput,
) => http<ProductAggregationSetting>(`${BASE_PATH}/${id}`, { method: 'PUT', data: input })
export const destroyProductAggregationSetting = (id: number) =>
  http(`${BASE_PATH}/${id}`, { method: 'DELETE' })
export const calculateProductAggregationSetting = (id: number) =>
  http(`${BASE_PATH}/${id}/calculate`, { method: 'POST' })
// 期間内の集計対象になる購入
export const getProductAggregationPurchases = (
  id: number,
  params: GetProductAggregationPurchasesParams,
) => http<GetProductAggregationPurchases>(`${BASE_PATH}/${id}/purchases`, { params })
export const getAllProductAggregationResults = () =>
  http<GetProductAggregationResults>('/api/v1/product_aggregation_results')
