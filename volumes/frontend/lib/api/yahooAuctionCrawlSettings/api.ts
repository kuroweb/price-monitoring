import type { CreateYahooAuctionCrawlSettingExcludeProductData } from './types'
import type { YahooAuctionCrawlSettingExcludeProduct } from '../models'

import { http } from '@/lib/axios-client'

const basePath = (productId: number) =>
  `/api/v1/products/${productId}/yahoo_auction_crawl_settings/yahoo_auction_crawl_setting_exclude_products`

export async function createYahooAuctionCrawlSettingExcludeProduct(
  productId: number,
  data: CreateYahooAuctionCrawlSettingExcludeProductData,
) {
  return http<YahooAuctionCrawlSettingExcludeProduct>(basePath(productId), {
    method: 'POST',
    data,
  })
}

export async function deleteYahooAuctionCrawlSettingExcludeProduct(productId: number, id: number) {
  return http(`${basePath(productId)}/${id}`, {
    method: 'DELETE',
  })
}
