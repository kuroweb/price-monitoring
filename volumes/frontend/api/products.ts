import type {
  Category,
  IosysCrawlSetting,
  JanparaCrawlSetting,
  MercariCrawlSetting,
  PcKoubouCrawlSetting,
  Product,
  UsedSofmapCrawlSetting,
  YahooAuctionCrawlSetting,
} from '@/api'

import { http } from '@/lib/axios-client'

// GET: /api/v1/products

export interface GetProductsParams {
  // TODO: 後で実装する
}

export type GetProducts = {
  products: (Product & {
    iosysCrawlSetting: IosysCrawlSetting
    janparaCrawlSetting: JanparaCrawlSetting
    mercariCrawlSetting: MercariCrawlSetting
    pcKoubouCrawlSetting: PcKoubouCrawlSetting
    usedSofmapCrawlSetting: UsedSofmapCrawlSetting
    yahooAuctionCrawlSetting: YahooAuctionCrawlSetting
    category: Category
  })[]
}

export async function getProducts(params?: GetProductsParams) {
  return http<GetProducts>('/api/v1/products', {
    method: 'GET',
    params,
  })
}

// GET: /api/v1/products

// export interface GetProduct extends Product {}

// export async function getProduct(productId: number) {
//   return http<GetProduct>(`/api/v1/products/${productId}`, {
//     method: 'GET',
//   })
// }

// POST: /api/v1/products

export type CreateProductData = {
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

export type CreateProduct = {
  products: Product & {
    iosysCrawlSetting: IosysCrawlSetting
    janparaCrawlSetting: JanparaCrawlSetting
    mercariCrawlSetting: MercariCrawlSetting
    pcKoubouCrawlSetting: PcKoubouCrawlSetting
    usedSofmapCrawlSetting: UsedSofmapCrawlSetting
    yahooAuctionCrawlSetting: YahooAuctionCrawlSetting
    category: Category
  }
}

export async function createProduct(data: CreateProductData) {
  return http<CreateProduct>('/api/v1/products', {
    method: 'POST',
    data,
  })
}

// PUT: /api/v1/products/:productId

export type UpdateProductData = {
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

export type UpdateProduct = {
  products: Product & {
    iosysCrawlSetting: IosysCrawlSetting
    janparaCrawlSetting: JanparaCrawlSetting
    mercariCrawlSetting: MercariCrawlSetting
    pcKoubouCrawlSetting: PcKoubouCrawlSetting
    usedSofmapCrawlSetting: UsedSofmapCrawlSetting
    yahooAuctionCrawlSetting: YahooAuctionCrawlSetting
    category: Category
  }
}

export async function updateProduct(productId: number, data: UpdateProductData) {
  return http<UpdateProduct>(`/api/v1/products/${productId}`, {
    method: 'PUT',
    data,
  })
}

// DELETE: /api/v1/products/:productId

export async function destroyProduct(productId: number) {
  return http(`/api/v1/products/${productId}`, {
    method: 'DELETE',
  })
}
