'use client'

import {
  copyExcludeKeyword,
  copyKeyword,
  copyMaxPrice,
  copyMinPrice,
  copyRequiredKeyword,
} from './lib/copyFields'

import type { CreateProductData } from '@/lib/api'
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
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyKeyword(getValues, setValue, 'yahooAuctionCrawlSetting.keyword')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>必須キーワード</legend>
        <textarea
          onChange={(e) => setRequiredKeywords(e.target.value)}
          defaultValue={requiredKeywordsText}
          className='textarea w-full h-32 text-base'
        />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() =>
            copyRequiredKeyword(
              getValues,
              setValue,
              'yahooAuctionCrawlSetting.yahooAuctionCrawlSettingRequiredKeywords',
            )
          }
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>除外キーワード</legend>
        <textarea
          onChange={(e) => setExcludeKeywords(e.target.value)}
          defaultValue={excludeKeywordsText}
          className='textarea w-full h-32 text-base'
        />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() =>
            copyExcludeKeyword(
              getValues,
              setValue,
              'yahooAuctionCrawlSetting.yahooAuctionCrawlSettingExcludeKeywords',
            )
          }
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>検索カテゴリ</legend>
        <input
          {...register('yahooAuctionCrawlSetting.categoryId', {
            setValueAs: (v) => (v === '' ? null : v),
          })}
          onChange={(e) => {
            const v = e.target.value
            console.log(v === '' ? undefined : v)
          }}
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
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMinPrice(getValues, setValue, 'yahooAuctionCrawlSetting.minPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>最高価格</legend>
        <input
          {...register('yahooAuctionCrawlSetting.maxPrice', { valueAsNumber: true })}
          className='input w-full'
        />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMaxPrice(getValues, setValue, 'yahooAuctionCrawlSetting.maxPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
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
