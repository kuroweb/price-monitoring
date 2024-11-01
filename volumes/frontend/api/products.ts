import type { Product } from './model'

import { http } from '@/lib/axios-client'

export interface GetProductsParams {
  // TODO: 後で実装する
}

export interface GetProductsData {
  products: Product[]
}

export async function getProducts(params?: GetProductsParams) {
  return http<GetProductsData>('/api/v1/products', {
    method: 'GET',
    params,
  })
}

export async function destroyProduct(productId: string) {
  return http(`/api/v1/products/${productId}`, {
    method: 'DELETE',
  })
}
