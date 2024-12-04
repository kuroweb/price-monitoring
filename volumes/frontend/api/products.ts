import type {
  Category,
  IosysCrawlSetting,
  IosysCrawlSettingExcludeKeyword,
  IosysCrawlSettingRequiredKeyword,
  JanparaCrawlSetting,
  JanparaCrawlSettingExcludeKeyword,
  JanparaCrawlSettingRequiredKeyword,
  MercariCrawlSetting,
  MercariCrawlSettingExcludeKeyword,
  MercariCrawlSettingRequiredKeyword,
  PcKoubouCrawlSetting,
  PcKoubouCrawlSettingExcludeKeyword,
  PcKoubouCrawlSettingRequiredKeyword,
  Product,
  UsedSofmapCrawlSetting,
  UsedSofmapCrawlSettingExcludeKeyword,
  UsedSofmapCrawlSettingRequiredKeyword,
  YahooAuctionCrawlSetting,
  YahooAuctionCrawlSettingExcludeKeyword,
  YahooAuctionCrawlSettingRequiredKeyword,
} from './model'

import { http } from '@/lib/axios-client'

export type ProductDetail = Product & {
  yahooAuctionCrawlSetting: YahooAuctionCrawlSetting & {
    yahooAuctionCrawlSettingExcludeKeywords: YahooAuctionCrawlSettingExcludeKeyword[]
    yahooAuctionCrawlSettingRequiredKeywords: YahooAuctionCrawlSettingRequiredKeyword[]
  }
  mercariCrawlSetting: MercariCrawlSetting & {
    mercariCrawlSettingExcludeKeywords: MercariCrawlSettingExcludeKeyword[]
    mercariCrawlSettingRequiredKeywords: MercariCrawlSettingRequiredKeyword[]
  }
  iosysCrawlSetting: IosysCrawlSetting & {
    iosysCrawlSettingExcludeKeywords: IosysCrawlSettingExcludeKeyword[]
    iosysCrawlSettingRequiredKeywords: IosysCrawlSettingRequiredKeyword[]
  }
  janparaCrawlSetting: JanparaCrawlSetting & {
    janparaCrawlSettingExcludeKeywords: JanparaCrawlSettingExcludeKeyword[]
    janparaCrawlSettingRequiredKeywords: JanparaCrawlSettingRequiredKeyword[]
  }
  pcKoubouCrawlSetting: PcKoubouCrawlSetting & {
    pcKoubouCrawlSettingExcludeKeywords: PcKoubouCrawlSettingExcludeKeyword[]
    pcKoubouCrawlSettingRequiredKeywords: PcKoubouCrawlSettingRequiredKeyword[]
  }
  usedSofmapCrawlSetting: UsedSofmapCrawlSetting & {
    usedSofmapCrawlSettingExcludeKeywords: UsedSofmapCrawlSettingExcludeKeyword[]
    usedSofmapCrawlSettingRequiredKeywords: UsedSofmapCrawlSettingRequiredKeyword[]
  }
  category: Category
}

export type ProductList = {
  products: ProductDetail[]
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
    yahooAuctionCrawlSettingExcludeKeywords: { keyword: string }[]
    yahooAuctionCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  mercariCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    mercariCrawlSettingExcludeKeywords: { keyword: string }[]
    mercariCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  iosysCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    iosysCrawlSettingExcludeKeywords: { keyword: string }[]
    iosysCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  janparaCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    janparaCrawlSettingExcludeKeywords: { keyword: string }[]
    janparaCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  pcKoubouCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    pcKoubouCrawlSettingExcludeKeywords: { keyword: string }[]
    pcKoubouCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  usedSofmapCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    usedSofmapCrawlSettingExcludeKeywords: { keyword: string }[]
    usedSofmapCrawlSettingRequiredKeywords: { keyword: string }[]
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
    yahooAuctionCrawlSettingExcludeKeywords: { keyword: string }[]
    yahooAuctionCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  mercariCrawlSetting: {
    categoryId: number | null
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    mercariCrawlSettingExcludeKeywords: { keyword: string }[]
    mercariCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  iosysCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    iosysCrawlSettingExcludeKeywords: { keyword: string }[]
    iosysCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  janparaCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    janparaCrawlSettingExcludeKeywords: { keyword: string }[]
    janparaCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  pcKoubouCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    pcKoubouCrawlSettingExcludeKeywords: { keyword: string }[]
    pcKoubouCrawlSettingRequiredKeywords: { keyword: string }[]
  }
  usedSofmapCrawlSetting: {
    enabled: boolean
    keyword: string
    maxPrice: number
    minPrice: number
    usedSofmapCrawlSettingExcludeKeywords: { keyword: string }[]
    usedSofmapCrawlSettingRequiredKeywords: { keyword: string }[]
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
