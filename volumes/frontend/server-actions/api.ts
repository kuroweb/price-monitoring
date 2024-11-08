'use server'

import * as Api from '@/api'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export async function getProducts(params?: Api.GetProductsParams) {
  return await Api.getProducts(params)
}

// export async function getProduct(productId: number) {
//   return await Api.getProduct(productId)
// }

export async function createProduct(params: Api.CreateProductData) {
  const res = await Api.createProduct(params)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return res
}

export async function updateProduct(productId: number, params: Api.UpdateProductData) {
  const res = await Api.updateProduct(productId, params)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return res
}

export async function destroyProduct(productId: number) {
  const res = await Api.destroyProduct(productId)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return res
}

export async function getCategories(params?: Api.GetCategoriesParams) {
  return await Api.getCategories(params)
}
