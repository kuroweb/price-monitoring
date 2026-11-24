'use server'

import { revalidatePaths } from '@/lib/revalidate-paths'

import * as CrawlResultApi from './crawlResults'
import * as CrawlApi from './crawlSettings'
import * as DailyMarketPriceApi from './dailyMarketPrices'
import * as MonitorApi from './monitors'

import type {
  GetMonitorTransactionsParams,
  GetMonitorCrawlResultsParams,
  GetCrawlResultsParams,
  SearchCrawlResultsParams,
  CrawlSettingInput,
  MonitorInput,
} from './types'

const revalidateCrawl = () => revalidatePaths([['/product-monitoring/crawl-settings', 'layout']])

export async function getCrawlSettings() {
  return CrawlApi.getCrawlSettings()
}

export async function createCrawlSetting(input: CrawlSettingInput) {
  const result = await CrawlApi.createCrawlSetting(input)
  if (result.data) revalidateCrawl()
  return result
}

export async function updateCrawlSetting(id: number, input: CrawlSettingInput) {
  const result = await CrawlApi.updateCrawlSetting(id, input)
  if (result.data) revalidateCrawl()
  return result
}

export async function destroyCrawlSetting(id: number) {
  const result = await CrawlApi.destroyCrawlSetting(id)
  if (result.status === 200) revalidateCrawl()
  return result
}

export async function syncCrawlSetting(id: number) {
  return CrawlApi.syncCrawlSetting(id)
}

export async function setCrawlResultExcluded(id: number, excluded: boolean) {
  const result = await CrawlResultApi.setCrawlResultExcluded(id, excluded)
  if (result.data) {
    revalidateCrawl()
    revalidatePaths([['/product-monitoring', 'layout']])
  }
  return result
}

export async function destroyCrawlResult(id: number) {
  const result = await CrawlResultApi.destroyCrawlResult(id)
  if (result.status === 200) {
    revalidateCrawl()
    revalidatePaths([['/product-monitoring', 'layout']])
  }
  return result
}

export async function getCrawlSetting(id: number) {
  return CrawlApi.getCrawlSetting(id)
}

export async function getCrawlResults(params?: GetCrawlResultsParams) {
  return CrawlResultApi.getCrawlResults(params)
}

export async function searchCrawlResults(params: SearchCrawlResultsParams) {
  return CrawlResultApi.searchCrawlResults(params)
}

const revalidateAggregation = () => revalidatePaths([['/product-monitoring', 'layout']])

export async function aggregateDailyMarketPrices(id: number) {
  const result = await MonitorApi.aggregateDailyMarketPrices(id)
  if (result.status === 200) revalidateAggregation()
  return result
}

export async function getDailyMarketPrices() {
  return DailyMarketPriceApi.getDailyMarketPrices()
}

export async function getMonitorTransactions(
  id: number,
  params: GetMonitorTransactionsParams,
) {
  return MonitorApi.getMonitorTransactions(id, params)
}

export async function getMonitors() {
  return MonitorApi.getMonitors()
}

export async function getMonitorCrawlResults(id: number, params?: GetMonitorCrawlResultsParams) {
  return MonitorApi.getMonitorCrawlResults(id, params)
}

export async function getMonitorSummary(id: number) {
  return MonitorApi.getMonitorSummary(id)
}

export async function createMonitor(input: MonitorInput) {
  const result = await MonitorApi.createMonitor(input)
  if (result.data) revalidatePaths([['/product-monitoring', 'layout']])
  return result
}

export async function updateMonitor(id: number, input: MonitorInput) {
  const result = await MonitorApi.updateMonitor(id, input)
  if (result.data) revalidatePaths([['/product-monitoring', 'layout']])
  return result
}

export async function destroyMonitor(id: number) {
  const result = await MonitorApi.destroyMonitor(id)
  if (result.status === 200) revalidatePaths([['/product-monitoring', 'layout']])
  return result
}
