import type {
  GetCategories,
  GetCategoriesParams,
  GetCategoriesStructuredParams,
  GetCategoryStructuredSubtreeParams,
  GetCategoryStructuredSubtree,
  CreateCategoryData,
  UpdateCategoryData,
  GetCategoriesStructured,
} from './types'
import type { Category } from '../models'

import { http } from '@/lib/axios-client'

const BASE_PATH = '/api/v1/categories'

export async function getCategories(params?: GetCategoriesParams) {
  return http<GetCategories>(BASE_PATH, {
    method: 'GET',
    params,
  })
}

export async function getCategoriesStructured(params?: GetCategoriesStructuredParams) {
  return http<GetCategoriesStructured>(`${BASE_PATH}/structured`, {
    method: 'GET',
    params,
  })
}

export async function getCategoryStructuredSubtree(
  categoryId: number,
  params?: GetCategoryStructuredSubtreeParams,
) {
  return http<GetCategoryStructuredSubtree>(`${BASE_PATH}/${categoryId}/structured_subtree`, {
    method: 'GET',
    params,
  })
}

export async function createCategory(data: CreateCategoryData) {
  return http<Category>(BASE_PATH, {
    method: 'POST',
    data,
  })
}

export async function updateCategory(categoryId: number, data: UpdateCategoryData) {
  return http<Category>(`${BASE_PATH}/${categoryId}`, {
    method: 'PATCH',
    data,
  })
}

export async function destroyCategory(categoryId: number) {
  return http(`${BASE_PATH}/${categoryId}`, {
    method: 'DELETE',
  })
}
