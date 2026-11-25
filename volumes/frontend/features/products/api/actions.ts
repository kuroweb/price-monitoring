'use server'

import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

import * as MercariApi from './mercariCrawlSettings'
import * as PricesApi from './productPrices'
import * as ProductsApi from './products'
import * as YahooAuctionApi from './yahooAuctionCrawlSettings'

import type * as Types from './types'

export async function getProducts(params?: Types.GetProductsParams) {
  return await ProductsApi.getProducts(params)
}

export async function getProduct(productId: number) {
  return await ProductsApi.getProduct(productId)
}

export async function createProduct(data: Types.CreateProductData) {
  const result = await ProductsApi.createProduct(data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function updateProduct(productId: number, data: Types.UpdateProductData) {
  const result = await ProductsApi.updateProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function destroyProduct(productId: number) {
  const result = await ProductsApi.destroyProduct(productId)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function getProductPrices(params: Types.GetProductPricesParams) {
  return await PricesApi.getProductPrices(params)
}

export async function getProductPrice(productId: number, params: Types.GetProductPriceParams) {
  return await PricesApi.getProductPrice(productId, params)
}

export async function createMercariCrawlSettingExcludeProduct(
  productId: number,
  data: Types.CreateMercariCrawlSettingExcludeProductData,
) {
  const result = await MercariApi.createMercariCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function createYahooAuctionCrawlSettingExcludeProduct(
  productId: number,
  data: Types.CreateYahooAuctionCrawlSettingExcludeProductData,
) {
  const result = await YahooAuctionApi.createYahooAuctionCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

