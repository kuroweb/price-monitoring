'use client'

import {
  copyKeyword,
  copyRequiredKeyword,
  copyExcludeKeyword,
  copyMinPrice,
  copyMaxPrice,
} from './lib/copyFields'

import type { UpdateProductData } from '@/lib/api'
import type { UseFormRegister, UseFormGetValues, UseFormSetValue } from 'react-hook-form'

const IosysForm = ({
  register,
  getValues,
  setValue,
}: {
  register: UseFormRegister<UpdateProductData>
  getValues: UseFormGetValues<UpdateProductData>
  setValue: UseFormSetValue<UpdateProductData>
}) => {
  const requiredKeywordsText = getValues('iosysCrawlSetting.iosysCrawlSettingRequiredKeywords')
    .map((requiredKeyword) => requiredKeyword.keyword)
    .join('\n')

  const excludeKeywordsText = getValues('iosysCrawlSetting.iosysCrawlSettingExcludeKeywords')
    .map((excludeKeyword) => excludeKeyword.keyword)
    .join('\n')

  const setRequiredKeywords = (value: string) => {
    const requiredKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('iosysCrawlSetting.iosysCrawlSettingRequiredKeywords', requiredKeywords)
  }

  const setExcludeKeywords = (value: string) => {
    const excludeKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('iosysCrawlSetting.iosysCrawlSettingExcludeKeywords', excludeKeywords)
  }

  return (
    <>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>検索キーワード</legend>
        <input {...register('iosysCrawlSetting.keyword')} className='input w-full' />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyKeyword(getValues, setValue, 'iosysCrawlSetting.keyword')}
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
              'iosysCrawlSetting.iosysCrawlSettingRequiredKeywords',
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
              'iosysCrawlSetting.iosysCrawlSettingExcludeKeywords',
            )
          }
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>最低価格</legend>
        <input
          {...register('iosysCrawlSetting.minPrice', { valueAsNumber: true })}
          className='input w-full'
        />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMinPrice(getValues, setValue, 'iosysCrawlSetting.minPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>最高価格</legend>
        <input {...register('iosysCrawlSetting.maxPrice')} className='input w-full' />
      </fieldset>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMaxPrice(getValues, setValue, 'iosysCrawlSetting.maxPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <label className='label cursor-pointer '>
        <span>自動計測</span>
        <input
          {...register('iosysCrawlSetting.enabled')}
          type='checkbox'
          className='toggle toggle-primary'
        />
      </label>
    </>
  )
}

export default IosysForm
