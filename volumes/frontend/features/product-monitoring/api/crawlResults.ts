import { http } from '@/lib/http-client'

import type {
  CrawlResult,
  GetCrawlResults,
  GetCrawlResultsParams,
  SearchCrawlResultsPage,
  SearchCrawlResultsParams,
} from './types'

const RESULTS_PATH = '/api/v1/product_monitoring/crawl_results'

export const getCrawlResults = (params?: GetCrawlResultsParams) =>
  http<GetCrawlResults>(RESULTS_PATH, { params })
export const searchCrawlResults = (data: SearchCrawlResultsParams) =>
  http<SearchCrawlResultsPage>(`${RESULTS_PATH}/search`, { method: 'POST', data })
export const setCrawlResultExcluded = (id: number, excluded: boolean) =>
  http<CrawlResult>(`${RESULTS_PATH}/${id}`, { method: 'PATCH', data: { excluded } })
export const destroyCrawlResult = (id: number) =>
  http(`${RESULTS_PATH}/${id}`, { method: 'DELETE' })
