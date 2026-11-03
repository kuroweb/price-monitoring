export type MeasurementUrl = { url: string; enabled: boolean }
export type ExcludedListing = { platform: string; externalId: string }
export type ProductSearchDraft = {
  name: string
  enabled: boolean
  minPrice: number | null
  maxPrice: number | null
  requiredKeywords: string[]
  excludeKeywords: string[]
  excludedListings: ExcludedListing[]
  urls: MeasurementUrl[]
}
export type ProductSearchSetting = ProductSearchDraft & { id: number }
export type ProductSearchPreview = {
  sources: {
    url: string
    platform: string | null
    status: 'succeeded' | 'failed' | 'unsupported' | 'disabled'
    error: string | null
    fetchedCount: number
  }[]
  results: {
    platform: string
    externalId: string
    name: string
    price: number | null
    url: string | null
    accepted: boolean
    reasons: string[]
  }[]
  fetchedCount: number
  acceptedCount: number
}
