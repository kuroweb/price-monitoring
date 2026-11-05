import type {
  ProductAggregationResult,
  ProductAggregationSetting,
  ProductAggregationSettingInput,
} from '../models'

export type GetProductAggregationSettings = {
  productAggregationSettings: ProductAggregationSetting[]
}
export type GetProductAggregationResults = { productAggregationResults: ProductAggregationResult[] }
export type { ProductAggregationResult, ProductAggregationSetting, ProductAggregationSettingInput }
