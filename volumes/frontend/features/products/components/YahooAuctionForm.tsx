'use client'

import type { CreateProductData } from '@/features/products/api/types'

import type { UseFormGetValues, UseFormRegister, UseFormSetValue } from 'react-hook-form'

const YahooAuctionForm = ({
  register,
  getValues,
  setValue,
}: {
  register: UseFormRegister<CreateProductData>
  getValues: UseFormGetValues<CreateProductData>
  setValue: UseFormSetValue<CreateProductData>
}) => {
  const requiredKeywordsText = getValues(
    'yahooAuctionCrawlSetting.yahooAuctionCrawlSettingRequiredKeywords',
  )
    .map((requiredKeyword) => requiredKeyword.keyword)
    .join('\n')

  const excludeKeywordsText = getValues(
    'yahooAuctionCrawlSetting.yahooAuctionCrawlSettingExcludeKeywords',
  )
    .map((excludeKeyword) => excludeKeyword.keyword)
    .join('\n')

  const setRequiredKeywords = (value: string) => {
    const requiredKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('yahooAuctionCrawlSetting.yahooAuctionCrawlSettingRequiredKeywords', requiredKeywords)
  }

  const setExcludeKeywords = (value: string) => {
    const excludeKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('yahooAuctionCrawlSetting.yahooAuctionCrawlSettingExcludeKeywords', excludeKeywords)
  }

  return (
    <>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>検索キーワード</legend>
        <input {...register('yahooAuctionCrawlSetting.keyword')} className='input w-full' />
      </fieldset>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>必須キーワード</legend>
        <textarea
          onChange={(e) => setRequiredKeywords(e.target.value)}
          defaultValue={requiredKeywordsText}
          className='textarea w-full h-32 text-base'
        />
      </fieldset>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>除外キーワード</legend>
        <textarea
          onChange={(e) => setExcludeKeywords(e.target.value)}
          defaultValue={excludeKeywordsText}
          className='textarea w-full h-32 text-base'
        />
      </fieldset>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>検索カテゴリ</legend>
        <input
          {...register('yahooAuctionCrawlSetting.categoryId', {
            setValueAs: (v) => (v === '' ? null : v),
          })}
          className='input w-full'
        />
      </fieldset>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>最低価格</legend>
        <input
          {...register('yahooAuctionCrawlSetting.minPrice', { valueAsNumber: true })}
          className='input w-full'
        />
      </fieldset>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>最高価格</legend>
        <input
          {...register('yahooAuctionCrawlSetting.maxPrice', { valueAsNumber: true })}
          className='input w-full'
        />
      </fieldset>
      <label className='label cursor-pointer'>
        <span>自動計測</span>
        <input
          {...register('yahooAuctionCrawlSetting.enabled')}
          type='checkbox'
          className='toggle toggle-primary'
        />
      </label>
    </>
  )
}

export default YahooAuctionForm
