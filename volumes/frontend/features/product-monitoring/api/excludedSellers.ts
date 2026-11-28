import { http } from '@/lib/http-client'

import type { ExcludedSeller, ExcludedSellerInput, GetExcludedSellers } from './types'

const BASE_PATH = '/api/v1/product_monitoring/excluded_sellers'

export const getExcludedSellers = () => http<GetExcludedSellers>(BASE_PATH)
export const createExcludedSeller = (input: ExcludedSellerInput) =>
  http<ExcludedSeller>(BASE_PATH, { method: 'POST', data: input })
export const destroyExcludedSeller = (id: number) =>
  http(`${BASE_PATH}/${id}`, { method: 'DELETE' })
