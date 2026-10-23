import { http } from '@/lib/http-client'

import type {
  GetProductPriceParams,
  GetProductPricesParams,
  ProductPriceDetail,
  ProductPriceList,
} from './types'

export async function getProductPrices(params: GetProductPricesParams) {
  return http<ProductPriceList>('/api/v1/product_prices', {
    method: 'GET',
    params,
  })
}

export async function getProductPrice(productId: number, params: GetProductPriceParams) {
  return http<ProductPriceDetail>(`/api/v1/product_prices/${productId}`, {
    method: 'GET',
    params,
  })
}
