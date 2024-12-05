import * as Api from '@/api'

export async function getCategories(params?: Api.GetCategoriesParams) {
  return await Api.getCategories(params)
}
