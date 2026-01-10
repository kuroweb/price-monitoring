import type { CreateProductData } from '@/lib/api'
import type { UseFormGetValues, UseFormSetValue } from 'react-hook-form'

// 検索キーワードのコピー

const keywordFields = [
  'yahooAuctionCrawlSetting.keyword',
  'mercariCrawlSetting.keyword',
  'janparaCrawlSetting.keyword',
  'iosysCrawlSetting.keyword',
  'pcKoubouCrawlSetting.keyword',
  'usedSofmapCrawlSetting.keyword',
] as const

export const copyKeyword = (
  getValues: UseFormGetValues<CreateProductData>,
  setValue: UseFormSetValue<CreateProductData>,
  source: (typeof keywordFields)[number],
) => {
  const value = getValues(source)
  keywordFields.filter((field) => field !== source).forEach((field) => setValue(field, value))
}

// 必須キーワードのコピー

const requiredKeywordFields = [
  'yahooAuctionCrawlSetting.yahooAuctionCrawlSettingRequiredKeywords',
  'mercariCrawlSetting.mercariCrawlSettingRequiredKeywords',
  'janparaCrawlSetting.janparaCrawlSettingRequiredKeywords',
  'iosysCrawlSetting.iosysCrawlSettingRequiredKeywords',
  'pcKoubouCrawlSetting.pcKoubouCrawlSettingRequiredKeywords',
  'usedSofmapCrawlSetting.usedSofmapCrawlSettingRequiredKeywords',
] as const

export const copyRequiredKeyword = (
  getValues: UseFormGetValues<CreateProductData>,
  setValue: UseFormSetValue<CreateProductData>,
  source: (typeof requiredKeywordFields)[number],
) => {
  const value = getValues(source)
  requiredKeywordFields
    .filter((field) => field !== source)
    .forEach((field) => setValue(field, value))
}

// 除外キーワードのコピー

const excludeKeywordFields = [
  'yahooAuctionCrawlSetting.yahooAuctionCrawlSettingExcludeKeywords',
  'mercariCrawlSetting.mercariCrawlSettingExcludeKeywords',
  'janparaCrawlSetting.janparaCrawlSettingExcludeKeywords',
  'iosysCrawlSetting.iosysCrawlSettingExcludeKeywords',
  'pcKoubouCrawlSetting.pcKoubouCrawlSettingExcludeKeywords',
  'usedSofmapCrawlSetting.usedSofmapCrawlSettingExcludeKeywords',
] as const

export const copyExcludeKeyword = (
  getValues: UseFormGetValues<CreateProductData>,
  setValue: UseFormSetValue<CreateProductData>,
  source: (typeof excludeKeywordFields)[number],
) => {
  const value = getValues(source)
  excludeKeywordFields
    .filter((field) => field !== source)
    .forEach((field) => setValue(field, value))
}

// 最低価格のコピー

const minPriceFields = [
  'yahooAuctionCrawlSetting.minPrice',
  'mercariCrawlSetting.minPrice',
  'janparaCrawlSetting.minPrice',
  'iosysCrawlSetting.minPrice',
  'pcKoubouCrawlSetting.minPrice',
  'usedSofmapCrawlSetting.minPrice',
] as const

export const copyMinPrice = (
  getValues: UseFormGetValues<CreateProductData>,
  setValue: UseFormSetValue<CreateProductData>,
  source: (typeof minPriceFields)[number],
) => {
  const value = getValues(source)
  minPriceFields.filter((field) => field !== source).forEach((field) => setValue(field, value))
}

// 最高価格のコピー

const maxPriceFields = [
  'yahooAuctionCrawlSetting.maxPrice',
  'mercariCrawlSetting.maxPrice',
  'janparaCrawlSetting.maxPrice',
  'iosysCrawlSetting.maxPrice',
  'pcKoubouCrawlSetting.maxPrice',
  'usedSofmapCrawlSetting.maxPrice',
] as const

export const copyMaxPrice = (
  getValues: UseFormGetValues<CreateProductData>,
  setValue: UseFormSetValue<CreateProductData>,
  source: (typeof maxPriceFields)[number],
) => {
  const value = getValues(source)
  maxPriceFields.filter((field) => field !== source).forEach((field) => setValue(field, value))
}
