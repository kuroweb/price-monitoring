import type { Category } from '../models'

export type GetCategoriesParams = {
  rootOnly?: boolean
}

export type GetCategories = {
  categories: Category[]
}

export type GetCategoriesStructuredParams = {
  rootOnly?: boolean
  displayDepthLimit?: number
}

export type GetCategoryStructuredSubtreeParams = {
  rootOnly?: boolean
  displayDepthLimit?: number
}

export type GetCategoryStructuredSubtree = Category & {
  parent: Category | null
  children: Category[]
}
