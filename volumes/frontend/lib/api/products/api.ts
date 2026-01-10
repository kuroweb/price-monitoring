import type {
  CreateProductData,
  GetProductsParams,
  ProductDetail,
  ProductList,
  UpdateProductData,
} from './types'
import type { Product } from '../models'

import { http } from '@/lib/axios-client'

export async function getProducts(params?: GetProductsParams) {
  return http<ProductList>('/api/v1/products', {
    method: 'GET',
    params,
  })
}

export async function getProduct(productId: number) {
  return http<ProductDetail>(`/api/v1/products/${productId}`, {
    method: 'GET',
  })
}

export async function createProduct(data: CreateProductData) {
  return http<Product>('/api/v1/products', {
    method: 'POST',
    data,
  })
}

export async function updateProduct(productId: number, data: UpdateProductData) {
  return http<Product>(`/api/v1/products/${productId}`, {
    method: 'PUT',
    data,
  })
}

export async function destroyProduct(productId: number) {
  return http(`/api/v1/products/${productId}`, {
    method: 'DELETE',
  })
}
