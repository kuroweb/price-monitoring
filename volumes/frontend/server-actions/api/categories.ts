import * as Api from '@/api'

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
