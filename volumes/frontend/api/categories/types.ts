import type { Category } from "../models"

export interface GetCategoriesParams {
  rootOnly?: boolean
}

export interface GetCategories {
  categories: Category[]
}
