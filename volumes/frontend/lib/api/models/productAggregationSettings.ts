export type ProductAggregationSettingDraft = {
  name: string
  requiredKeywords: string[]
  excludeKeywords: string[]
  minPrice: number | null
  maxPrice: number | null
}
export type ProductAggregationSetting = ProductAggregationSettingDraft & { id: number }
export type ProductAggregationResult = {
  id: number
  productAggregationSettingId: number
  date: string
  averagePurchasePrice: number | null
  purchaseCount: number
}
