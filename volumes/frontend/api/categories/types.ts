import type { Category } from '../models'

export type GetCategoriesParams = {
  rootOnly?: boolean
}

export type GetCategories = {
  categories: Category[]
}
