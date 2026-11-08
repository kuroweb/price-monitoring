'use server'

import { revalidateAdminCategoriesPaths } from '@/lib/revalidate-paths'

import * as Api from './categories'

import type * as Types from './types'

export async function getCategories(params?: Types.GetCategoriesParams) {
  return await Api.getCategories(params)
}

export async function getCategoriesStructured(params?: Types.GetCategoriesStructuredParams) {
  return await Api.getCategoriesStructured(params)
}

export async function getCategoryStructuredSubtree(
  categoryId: number,
  params?: Types.GetCategoryStructuredSubtreeParams,
) {
  return await Api.getCategoryStructuredSubtree(categoryId, params)
}

export async function createCategory(data: Types.CreateCategoryData) {
  const result = await Api.createCategory(data)
  revalidateAdminCategoriesPaths()
  return result
}

export async function updateCategory(categoryId: number, data: Types.UpdateCategoryData) {
  const result = await Api.updateCategory(categoryId, data)
  revalidateAdminCategoriesPaths()
  return result
}

export async function destroyCategory(categoryId: number) {
  const result = await Api.destroyCategory(categoryId)
  revalidateAdminCategoriesPaths()
  return result
}
