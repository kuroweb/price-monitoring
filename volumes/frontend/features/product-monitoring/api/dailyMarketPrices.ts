import { http } from '@/lib/http-client'

import type { GetDailyMarketPrices } from './types'

export const getDailyMarketPrices = () =>
  http<GetDailyMarketPrices>('/api/v1/product_monitoring/daily_market_prices')
