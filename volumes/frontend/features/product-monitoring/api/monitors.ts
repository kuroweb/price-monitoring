import { http } from '@/lib/http-client'

import type {
  GetCrawlResults,
  GetMonitorSummary,
  GetMonitorTransactions,
  GetMonitorTransactionsParams,
  GetMonitors,
  Monitor,
  MonitorInput,
} from './types'

const BASE_PATH = '/api/v1/product_monitoring/monitors'

export const getMonitors = () => http<GetMonitors>(BASE_PATH)
export const getMonitorCrawlResults = (id: number) =>
  http<GetCrawlResults>(`${BASE_PATH}/${id}/crawl_results`)
// 一覧に出す最安値と直近の平均取引価格
export const getMonitorSummary = (id: number) =>
  http<GetMonitorSummary>(`${BASE_PATH}/${id}/summary`)
export const createMonitor = (input: MonitorInput) =>
  http<Monitor>(BASE_PATH, { method: 'POST', data: input })
export const updateMonitor = (id: number, input: MonitorInput) =>
  http<Monitor>(`${BASE_PATH}/${id}`, { method: 'PUT', data: input })
export const destroyMonitor = (id: number) =>
  http(`${BASE_PATH}/${id}`, { method: 'DELETE' })

export const aggregateDailyMarketPrices = (id: number) =>
  http(`${BASE_PATH}/${id}/aggregate_daily_market_prices`, { method: 'POST' })
// 期間内の集計対象になる取引
export const getMonitorTransactions = (
  id: number,
  params: GetMonitorTransactionsParams,
) => http<GetMonitorTransactions>(`${BASE_PATH}/${id}/transactions`, { params })
