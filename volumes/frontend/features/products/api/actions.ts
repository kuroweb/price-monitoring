'use server'

import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

import * as IosysApi from './iosysCrawlSettings'
import * as JanparaApi from './janparaCrawlSettings'
import * as MercariApi from './mercariCrawlSettings'
import * as PcKoubouApi from './pcKoubouCrawlSettings'
import * as PricesApi from './productPrices'
import * as ProductsApi from './products'
import * as UsedSofmapApi from './usedSofmapCrawlSettings'
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

export async function createIosysCrawlSettingExcludeProduct(
  productId: number,
  data: Types.CreateIosysCrawlSettingExcludeProductData,
) {
  const result = await IosysApi.createIosysCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function createJanparaCrawlSettingExcludeProduct(
  productId: number,
  data: Types.CreateJanparaCrawlSettingExcludeProductData,
) {
  const result = await JanparaApi.createJanparaCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
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

export async function createPcKoubouCrawlSettingExcludeProduct(
  productId: number,
  data: Types.CreatePcKoubouCrawlSettingExcludeProductData,
) {
  const result = await PcKoubouApi.createPcKoubouCrawlSettingExcludeProduct(productId, data)
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export async function createUsedSofmapCrawlSettingExcludeProduct(
  productId: number,
  data: Types.CreateUsedSofmapCrawlSettingExcludeProductData,
) {
  const result = await UsedSofmapApi.createUsedSofmapCrawlSettingExcludeProduct(productId, data)
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

