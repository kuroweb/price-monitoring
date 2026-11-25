import { createParser, parseAsString, parseAsStringLiteral, useQueryStates } from 'nuqs'

import type {
  MonitorCrawlResultSort,
  MonitorSaleStatus,
} from '@/features/product-monitoring/api/types'

const SALE_STATUSES = ['all', 'on_sale', 'sold'] as const
const SORTS = ['newest', 'price_asc', 'price_desc'] as const

// parseAsInteger は parseInt なので "10.5" を 10 として受けてしまう。円の入力はそのまま往復させる。
const parseAsPrice = createParser({
  parse(value: string) {
    if (!/^-?(?:0|[1-9]\d*)(?:\.\d+)?$/.test(value)) return null
    const price = Number(value)
    return Number.isFinite(price) ? price : null
  },
  serialize(value: number) {
    return String(value)
  },
})

const parseAsPage = createParser({
  parse(value: string) {
    if (!/^[1-9]\d*$/.test(value)) return null
    const page = Number(value)
    return Number.isSafeInteger(page) ? page : null
  },
  serialize(value: number) {
    return String(value)
  },
}).withDefault(1)

export const crawlResultSearchParsers = {
  required: parseAsString.withDefault(''),
  excluded: parseAsString.withDefault(''),
  min_price: parseAsPrice,
  max_price: parseAsPrice,
  sale_status: parseAsStringLiteral(SALE_STATUSES).withDefault('all'),
  sort: parseAsStringLiteral(SORTS).withDefault('newest'),
  page: parseAsPage,
}

export type CrawlResultSearchQuery = {
  required: string
  excluded: string
  min_price: number | null
  max_price: number | null
  sale_status: MonitorSaleStatus
  sort: MonitorCrawlResultSort
  page: number
}

export function isInitialCrawlResultSearchQuery(query: CrawlResultSearchQuery) {
  return (
    query.required === '' &&
    query.excluded === '' &&
    query.min_price == null &&
    query.max_price == null &&
    query.sale_status === 'all' &&
    query.sort === 'newest' &&
    query.page === 1
  )
}

export function useCrawlResultSearchQuery() {
  return useQueryStates(crawlResultSearchParsers)
}
