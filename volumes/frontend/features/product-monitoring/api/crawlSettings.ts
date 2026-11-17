import { http } from '@/lib/http-client'

import type {
  GetCrawlSettings,
  CrawlSetting,
  CrawlSettingInput,
} from './types'

const BASE_PATH = '/api/v1/product_monitoring/crawl_settings'

export const getCrawlSettings = () => http<GetCrawlSettings>(BASE_PATH)
export const getCrawlSetting = (id: number) =>
  http<CrawlSetting>(`${BASE_PATH}/${id}`)
export const createCrawlSetting = (input: CrawlSettingInput) =>
  http<CrawlSetting>(BASE_PATH, { method: 'POST', data: input })
export const updateCrawlSetting = (id: number, input: CrawlSettingInput) =>
  http<CrawlSetting>(`${BASE_PATH}/${id}`, { method: 'PUT', data: input })
export const destroyCrawlSetting = (id: number) =>
  http(`${BASE_PATH}/${id}`, { method: 'DELETE' })
export const syncCrawlSetting = (id: number) =>
  http<Record<string, never>>(`${BASE_PATH}/${id}/sync`, { method: 'POST' })
