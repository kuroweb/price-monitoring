'use client'

import {
  copyKeyword,
  copyRequiredKeyword,
  copyExcludeKeyword,
  copyMaxPrice,
  copyMinPrice,
} from './lib/copyFields'

import type { CreateProductData } from '@/lib/api'
import type { UseFormGetValues, UseFormRegister, UseFormSetValue } from 'react-hook-form'

const UsedSofmapForm = ({
  register,
  getValues,
  setValue,
}: {
  register: UseFormRegister<CreateProductData>
  getValues: UseFormGetValues<CreateProductData>
  setValue: UseFormSetValue<CreateProductData>
}) => {
  const requiredKeywordsText = getValues(
    'usedSofmapCrawlSetting.usedSofmapCrawlSettingRequiredKeywords',
  )
    .map((requiredKeyword) => requiredKeyword.keyword)
    .join('\n')

  const excludeKeywordsText = getValues(
    'usedSofmapCrawlSetting.usedSofmapCrawlSettingExcludeKeywords',
  )
    .map((excludeKeyword) => excludeKeyword.keyword)
    .join('\n')

  const setRequiredKeywords = (value: string) => {
    const requiredKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('usedSofmapCrawlSetting.usedSofmapCrawlSettingRequiredKeywords', requiredKeywords)
  }

  const setExcludeKeywords = (value: string) => {
    const excludeKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('usedSofmapCrawlSetting.usedSofmapCrawlSettingExcludeKeywords', excludeKeywords)
  }

  return (
    <>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>検索キーワード</legend>
        <input {...register('usedSofmapCrawlSetting.keyword')} className='input w-full' />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyKeyword(getValues, setValue, 'usedSofmapCrawlSetting.keyword')}
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
              'usedSofmapCrawlSetting.usedSofmapCrawlSettingRequiredKeywords',
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
              'usedSofmapCrawlSetting.usedSofmapCrawlSettingExcludeKeywords',
            )
          }
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>最低価格</legend>
        <input
          {...register('usedSofmapCrawlSetting.minPrice', { valueAsNumber: true })}
          className='input w-full'
        />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMinPrice(getValues, setValue, 'usedSofmapCrawlSetting.minPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>最高価格</legend>
        <input
          {...register('usedSofmapCrawlSetting.maxPrice', { valueAsNumber: true })}
          className='input w-full'
        />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMaxPrice(getValues, setValue, 'usedSofmapCrawlSetting.maxPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <label className='label cursor-pointer'>
        <span>自動計測</span>
        <input
          {...register('usedSofmapCrawlSetting.enabled')}
          type='checkbox'
          className='toggle toggle-primary'
        />
      </label>
    </>
  )
}

export default UsedSofmapForm
