import type { Product } from './model'

import { http } from '@/lib/axios-client'

export interface GetProductsParams {
  // TODO: 後で実装する
}

// GET

export interface GetProducts {
  products: Product[]
}

export async function getProducts(params?: GetProductsParams) {
  return http<GetProducts>('/api/v1/products', {
    method: 'GET',
    params,
  })
}

// CREATE

export interface CreateProductData {
  name: string
  categoryId: number
  yahooAuctionCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  mercariCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  iosysCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  janparaCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  pcKoubouCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  usedSofmapCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
}

export interface CreateProduct extends Product {}

export async function createProduct(data: CreateProductData) {
  return http<CreateProduct>('/api/v1/products', {
    method: 'POST',
    data,
  })
}

// UPDATE

export interface UpdateProductData {
  name: string
  categoryId: number
  yahooAuctionCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  mercariCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  iosysCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  janparaCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  pcKoubouCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
  usedSofmapCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
  }
}

export interface UpdateProduct extends Product {}

export async function updateProduct(productId: number, data: UpdateProductData) {
  return http<UpdateProduct>(`/api/v1/products/${productId}`, {
    method: 'PUT',
    data,
  })
}

// DELETE

export async function destroyProduct(productId: number) {
  return http(`/api/v1/products/${productId}`, {
    method: 'DELETE',
  })
}
