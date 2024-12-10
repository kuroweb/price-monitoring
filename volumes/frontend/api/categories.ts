import type { Category } from './models'

import { http } from '@/lib/axios-client'

export interface GetCategoriesParams {
  rootOnly?: boolean
}

export interface GetCategories {
  categories: Category[]
}

export async function getCategories(params?: GetCategoriesParams) {
  return http<GetCategories>('/api/v1/categories', {
    method: 'GET',
    params,
  })
}
