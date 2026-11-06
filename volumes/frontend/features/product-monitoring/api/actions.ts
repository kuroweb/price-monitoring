'use server'

import { revalidatePaths } from '@/lib/revalidate-paths'

import * as AggregationApi from './aggregationSettings'
import * as CrawlApi from './crawlSettings'

import type {
  GetProductCrawlResultsParams,
  ProductAggregationSettingInput,
  ProductCrawlSettingInput,
} from './types'

const revalidateCrawl = () =>
  revalidatePaths([
    ['/admin/product-crawl-settings', 'page'],
    ['/product-crawl-results', 'layout'],
  ])

export async function getProductCrawlSettings() {
  return CrawlApi.getProductCrawlSettings()
}

export async function createProductCrawlSetting(input: ProductCrawlSettingInput) {
  const result = await CrawlApi.createProductCrawlSetting(input)
  if (result.data) revalidateCrawl()
  return result
}

export async function updateProductCrawlSetting(id: number, input: ProductCrawlSettingInput) {
  const result = await CrawlApi.updateProductCrawlSetting(id, input)
  if (result.data) revalidateCrawl()
  return result
}

export async function destroyProductCrawlSetting(id: number) {
  const result = await CrawlApi.destroyProductCrawlSetting(id)
  if (result.status === 200) revalidateCrawl()
  return result
}

export async function syncProductCrawlSetting(id: number) {
  const result = await CrawlApi.syncProductCrawlSetting(id)
  if (result.data) revalidateCrawl()
  return result
}

export async function setProductCrawlResultExcluded(id: number, excluded: boolean) {
  const result = await CrawlApi.setProductCrawlResultExcluded(id, excluded)
  if (result.data) revalidateCrawl()
  return result
}

export async function getProductCrawlSetting(id: number) {
  return CrawlApi.getProductCrawlSetting(id)
}

export async function getProductCrawlResults(params?: GetProductCrawlResultsParams) {
  return CrawlApi.getProductCrawlResults(params)
}

const revalidateAggregation = () =>
  revalidatePaths([
    ['/admin/product-aggregation-settings', 'page'],
    ['/product-aggregation-results', 'page'],
  ])

export async function getProductAggregationSettings() {
  return AggregationApi.getProductAggregationSettings()
}

export async function createProductAggregationSetting(input: ProductAggregationSettingInput) {
  const result = await AggregationApi.createProductAggregationSetting(input)
  if (result.data) revalidateAggregation()
  return result
}

export async function updateProductAggregationSetting(
  id: number,
  input: ProductAggregationSettingInput,
) {
  const result = await AggregationApi.updateProductAggregationSetting(id, input)
  if (result.data) revalidateAggregation()
  return result
}

export async function destroyProductAggregationSetting(id: number) {
  const result = await AggregationApi.destroyProductAggregationSetting(id)
  if (result.status === 200) revalidateAggregation()
  return result
}

export async function calculateProductAggregationSetting(id: number) {
  const result = await AggregationApi.calculateProductAggregationSetting(id)
  if (result.status === 200) revalidateAggregation()
  return result
}

export async function getAllProductAggregationResults() {
  return AggregationApi.getAllProductAggregationResults()
}
