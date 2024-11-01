'use server'

import * as Api from '../api'

export async function getProducts(params?: Api.GetProductsParams) {
  return await Api.getProducts(params)
}

export async function destroyProduct(productId: string) {
  return await Api.destroyProduct(productId)
}

export async function getCategories(params?: Api.GetCategoriesParams) {
  return await Api.getCategories(params)
}
