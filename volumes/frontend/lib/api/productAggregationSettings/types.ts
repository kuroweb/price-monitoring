import type {
  ProductAggregationResult,
  ProductAggregationSetting,
  ProductAggregationSettingDraft,
} from '../models'

export type GetProductAggregationSettings = {
  productAggregationSettings: ProductAggregationSetting[]
}
export type GetProductAggregationResults = { productAggregationResults: ProductAggregationResult[] }
export type { ProductAggregationResult, ProductAggregationSetting, ProductAggregationSettingDraft }
