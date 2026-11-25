import type { Category } from '@/lib/category'

export type Product = {
  id: number
  name: string
  createdAt: string
  updatedAt: string
}

export type RelatedProduct = {
  platform: string
  productId: number
  externalId: string
  name: string
  price: number
  buyoutPrice: number | null
  thumbnailUrl: string
  published: boolean
  boughtDate: string
  endDate: string
  createdAt: string
  updatedAt: string
}

export type ProductPriceList = (Product & {
  relatedProducts: RelatedProduct[]
})[]

export type ProductPriceDetail = Product & {
  relatedProducts: RelatedProduct[]
}

export type GetProductPricesParams = {
  categoryId: number | null
  platformMask: string
  sort: string
  order: string
  priceDisplayLimit: number
}

export type GetProductPriceParams = {
  platformMask: string
  sort: string
  order: string
  page: number
  per: number
}

export type ProductDetail = Product & {
  category: Category
}

export type ProductList = {
  products: (Product & {
    category: Category
  })[]
}

// TODO: 後で実装する
export type GetProductsParams = Record<string, never>

export type CreateProductData = {
  name: string
  categoryId: number | null
}

export type UpdateProductData = CreateProductData
