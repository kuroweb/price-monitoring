import type {
  ProductCrawlResult,
  ProductCrawlSetting,
  ProductCrawlSettingInput,
  ProductCrawlSyncResult,
} from '../models'

export type GetProductCrawlSettings = { productCrawlSettings: ProductCrawlSetting[] }
export type GetProductCrawlResults = { productCrawlResults: ProductCrawlResult[] }
export type GetProductCrawlResultsParams = { productCrawlSettingId?: number; excluded?: boolean }
export type {
  ProductCrawlResult,
  ProductCrawlSetting,
  ProductCrawlSettingInput,
  ProductCrawlSyncResult,
}
