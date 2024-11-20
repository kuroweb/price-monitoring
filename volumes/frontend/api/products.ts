import type {
  Category,
  IosysCrawlSetting,
  JanparaCrawlSetting,
  MercariCrawlSetting,
  PcKoubouCrawlSetting,
  Product,
  UsedSofmapCrawlSetting,
  YahooAuctionCrawlSetting,
} from './model'

import { http } from '@/lib/axios-client'

export type ProductList = {
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

export type ProductDetail = Product & {
  iosysCrawlSetting: IosysCrawlSetting & {
    iosysCrawlSettingExcludeKeywords: IosysCrawlSettingExcludeKeyword[]
  }
  janparaCrawlSetting: JanparaCrawlSetting & {
    janparaCrawlSettingExcludeKeywords: JanparaCrawlSettingExcludeKeyword[]
  }
  mercariCrawlSetting: MercariCrawlSetting & {
    mercariCrawlSettingExcludeKeywords: MercariCrawlSettingExcludeKeyword[]
  }
  pcKoubouCrawlSetting: PcKoubouCrawlSetting & {
    pcKoubouCrawlSettingExcludeKeywords: PcKoubouCrawlSettingExcludeKeyword[]
  }
  usedSofmapCrawlSetting: UsedSofmapCrawlSetting & {
    usedSofmapCrawlSettingExcludeKeywords: UsedSomapCrawlSettingExcludeKeyword[]
  }
  yahooAuctionCrawlSetting: YahooAuctionCrawlSetting & {
    yahooAuctionCrawlSettingExcludeKeywords: YahooAuctionCrawlSettingExcludeKeyword[]
  }
  category: Category
}

export interface GetProductsParams {
  // TODO: 後で実装する
}

export async function getProducts(params?: GetProductsParams) {
  return http<ProductList>('/api/v1/products', {
    method: 'GET',
    params,
  })
}

export async function getProduct(productId: number) {
  return http<ProductDetail>(`/api/v1/products/${productId}`, {
    method: 'GET',
  })
}

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

export async function createProduct(data: CreateProductData) {
  return http<Product>('/api/v1/products', {
    method: 'POST',
    data,
  })
}

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

export async function updateProduct(productId: number, data: UpdateProductData) {
  return http<Product>(`/api/v1/products/${productId}`, {
    method: 'PUT',
    data,
  })
}

export async function destroyProduct(productId: number) {
  return http(`/api/v1/products/${productId}`, {
    method: 'DELETE',
  })
}
