'use client'

import {
  copyRequiredKeyword,
  copyExcludeKeyword,
  copyKeyword,
  copyMaxPrice,
  copyMinPrice,
} from './lib/copyFields'

import type { CreateProductData } from '@/lib/api'
import type { UseFormGetValues, UseFormRegister, UseFormSetValue } from 'react-hook-form'

const MercariForm = ({
  register,
  getValues,
  setValue,
}: {
  register: UseFormRegister<CreateProductData>
  getValues: UseFormGetValues<CreateProductData>
  setValue: UseFormSetValue<CreateProductData>
}) => {
  const requiredKeywordsText = getValues('mercariCrawlSetting.mercariCrawlSettingRequiredKeywords')
    .map((requiredKeyword) => requiredKeyword.keyword)
    .join('\n')

  const excludeKeywordsText = getValues('mercariCrawlSetting.mercariCrawlSettingExcludeKeywords')
    .map((excludeKeyword) => excludeKeyword.keyword)
    .join('\n')

  const setRequiredKeywords = (value: string) => {
    const requiredKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('mercariCrawlSetting.mercariCrawlSettingRequiredKeywords', requiredKeywords)
  }

  const setExcludeKeywords = (value: string) => {
    const excludeKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('mercariCrawlSetting.mercariCrawlSettingExcludeKeywords', excludeKeywords)
  }

  return (
    <>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>検索キーワード</legend>
        <input {...register('mercariCrawlSetting.keyword')} className='input w-full' />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyKeyword(getValues, setValue, 'mercariCrawlSetting.keyword')}
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
              'mercariCrawlSetting.mercariCrawlSettingRequiredKeywords',
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
              'mercariCrawlSetting.mercariCrawlSettingExcludeKeywords',
            )
          }
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>検索カテゴリ</legend>
        <input
          {...register('mercariCrawlSetting.categoryId', {
            setValueAs: (v) => (v === '' ? null : v),
          })}
          className='input w-full'
        />
      </fieldset>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>最低価格</legend>
        <input
          {...register('mercariCrawlSetting.minPrice', { valueAsNumber: true })}
          className='input w-full'
        />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMinPrice(getValues, setValue, 'mercariCrawlSetting.minPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>最高価格</legend>
        <input
          {...register('mercariCrawlSetting.maxPrice', { valueAsNumber: true })}
          className='input w-full'
        />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMaxPrice(getValues, setValue, 'mercariCrawlSetting.maxPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <label className='label cursor-pointer'>
        <span>自動計測</span>
        <input
          {...register('mercariCrawlSetting.enabled')}
          type='checkbox'
          className='toggle toggle-primary'
        />
      </label>
    </>
  )
}

export default MercariForm
