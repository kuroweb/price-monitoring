import type {
  GetCategories,
  GetCategoriesParams,
  GetCategoriesStructuredParams,
  GetCategoryStructuredSubtreeParams,
  GetCategoryStructuredSubtree,
} from './types'

import { http } from '@/lib/axios-client'

export async function getCategories(params?: GetCategoriesParams) {
  return http<GetCategories>('/api/v1/categories', {
    method: 'GET',
    params,
  })
}

export async function getCategoriesStructured(params?: GetCategoriesStructuredParams) {
  return http<GetCategories>('/api/v1/categories/structured', {
    method: 'GET',
    params,
  })
}

export async function getCategoryStructuredSubtree(
  categoryId: number,
  params?: GetCategoryStructuredSubtreeParams,
) {
  return http<GetCategoryStructuredSubtree>(`/api/v1/categories/${categoryId}/structured_subtree`, {
    method: 'GET',
    params,
  })
}
