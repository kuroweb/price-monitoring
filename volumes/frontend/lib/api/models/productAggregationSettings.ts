export type ProductAggregationSettingInput = {
  name: string
  requiredKeywords: string[]
  excludeKeywords: string[]
  minPrice: number | null
  maxPrice: number | null
}
export type ProductAggregationSetting = ProductAggregationSettingInput & { id: number }
export type ProductAggregationResult = {
  id: number
  productAggregationSettingId: number
  date: string
  averagePurchasePrice: number | null
  purchaseCount: number
}
