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

export async function createCategory(data: Api.CreateCategoryData) {
  return await Api.createCategory(data)
}

export async function destroyCategory(categoryId: number) {
  return await Api.destroyCategory(categoryId)
}
