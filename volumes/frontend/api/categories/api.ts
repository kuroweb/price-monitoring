import type { GetCategories, GetCategoriesParams } from './types'

import { http } from '@/lib/axios-client'

export async function getCategories(params?: GetCategoriesParams) {
  return http<GetCategories>('/api/v1/categories', {
    method: 'GET',
    params,
  })
}
