'use server'

import * as Api from '@/lib/api'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export async function getProducts(params?: Api.GetProductsParams) {
  return await Api.getProducts(params)
}

export async function getProduct(productId: number) {
  return await Api.getProduct(productId)
}

export async function createProduct(data: Api.CreateProductData) {
  const result = await Api.createProduct(data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function updateProduct(productId: number, data: Api.UpdateProductData) {
  const result = await Api.updateProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function destroyProduct(productId: number) {
  const result = await Api.destroyProduct(productId)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
