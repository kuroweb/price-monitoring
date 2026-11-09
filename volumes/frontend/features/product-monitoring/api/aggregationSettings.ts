import { http } from '@/lib/http-client'

import type {
  GetProductAggregationPurchases,
  GetProductAggregationPurchasesParams,
  GetProductAggregationResults,
} from './types'

const BASE_PATH = '/api/v1/product_watch_settings'

export const calculateProductAggregationSetting = (id: number) =>
  http(`${BASE_PATH}/${id}/calculate`, { method: 'POST' })
// 期間内の集計対象になる購入
export const getProductAggregationPurchases = (
  id: number,
  params: GetProductAggregationPurchasesParams,
) => http<GetProductAggregationPurchases>(`${BASE_PATH}/${id}/purchases`, { params })
export const getAllProductAggregationResults = () =>
  http<GetProductAggregationResults>('/api/v1/product_aggregation_results')
