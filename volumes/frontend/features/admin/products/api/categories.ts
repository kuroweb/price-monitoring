import type { Category } from './model'

import { http } from '@/lib/axios-client'

export interface GetCategoriesParams {
  rootOnly?: boolean
}

export interface GetCategoriesData {
  categories: Category[]
}

export async function getCategories(params?: GetCategoriesParams) {
  return http<GetCategoriesData>('/api/v1/categories', {
    method: 'GET',
    params,
  })
}
