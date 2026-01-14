'use server'

import * as Api from '@/lib/api'
import { revalidateAdminCategoriesPaths } from '@/lib/revalidate-paths'

export async function getCategories(params?: Api.GetCategoriesParams) {
  return await Api.getCategories(params)
}

export async function getCategoriesStructured(params?: Api.GetCategoriesStructuredParams) {
  return await Api.getCategoriesStructured(params)
}

export async function getCategoryStructuredSubtree(
  categoryId: number,
  params?: Api.GetCategoryStructuredSubtreeParams,
) {
  return await Api.getCategoryStructuredSubtree(categoryId, params)
}

export async function createCategory(data: Api.CreateCategoryData) {
  const result = await Api.createCategory(data)
  revalidateAdminCategoriesPaths()
  return result
}

export async function updateCategory(categoryId: number, data: Api.UpdateCategoryData) {
  const result = await Api.updateCategory(categoryId, data)
  revalidateAdminCategoriesPaths()
  return result
}

export async function destroyCategory(categoryId: number) {
  const result = await Api.destroyCategory(categoryId)
  revalidateAdminCategoriesPaths()
  return result
}
