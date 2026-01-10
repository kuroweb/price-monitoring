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

const PcKoubouForm = ({
  register,
  getValues,
  setValue,
}: {
  register: UseFormRegister<UpdateProductData>
  getValues: UseFormGetValues<UpdateProductData>
  setValue: UseFormSetValue<UpdateProductData>
}) => {
  const requiredKeywordsText = getValues(
    'pcKoubouCrawlSetting.pcKoubouCrawlSettingRequiredKeywords',
  )
    .map((requiredKeyword) => requiredKeyword.keyword)
    .join('\n')

  const excludeKeywordsText = getValues('pcKoubouCrawlSetting.pcKoubouCrawlSettingExcludeKeywords')
    .map((excludeKeyword) => excludeKeyword.keyword)
    .join('\n')

  const setRequiredKeywords = (value: string) => {
    const requiredKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('pcKoubouCrawlSetting.pcKoubouCrawlSettingRequiredKeywords', requiredKeywords)
  }

  const setExcludeKeywords = (value: string) => {
    const excludeKeywords = value
      .split(/\r?\n/)
      .filter((value) => value.trim() !== '')
      .map((value) => ({ keyword: value }))
    setValue('pcKoubouCrawlSetting.pcKoubouCrawlSettingExcludeKeywords', excludeKeywords)
  }

  return (
    <>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>検索キーワード</span>
        </div>
        <input {...register('pcKoubouCrawlSetting.keyword')} className='input input-bordered' />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyKeyword(getValues, setValue, 'pcKoubouCrawlSetting.keyword')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>必須キーワード</span>
        </div>
        <textarea
          onChange={(e) => setRequiredKeywords(e.target.value)}
          defaultValue={requiredKeywordsText}
          className='textarea textarea-bordered h-32 text-base'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() =>
            copyRequiredKeyword(
              getValues,
              setValue,
              'pcKoubouCrawlSetting.pcKoubouCrawlSettingRequiredKeywords',
            )
          }
        >
          他の検索サイトにコピー
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>除外キーワード</span>
        </div>
        <textarea
          onChange={(e) => setExcludeKeywords(e.target.value)}
          defaultValue={excludeKeywordsText}
          className='textarea textarea-bordered h-32 text-base'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() =>
            copyExcludeKeyword(
              getValues,
              setValue,
              'pcKoubouCrawlSetting.pcKoubouCrawlSettingExcludeKeywords',
            )
          }
        >
          他の検索サイトにコピー
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最低価格</span>
        </div>
        <input
          {...register('pcKoubouCrawlSetting.minPrice', { valueAsNumber: true })}
          className='input input-bordered'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMinPrice(getValues, setValue, 'pcKoubouCrawlSetting.minPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最高価格</span>
        </div>
        <input
          {...register('pcKoubouCrawlSetting.maxPrice', { valueAsNumber: true })}
          className='input input-bordered'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => copyMaxPrice(getValues, setValue, 'pcKoubouCrawlSetting.maxPrice')}
        >
          他の検索サイトにコピー
        </button>
      </div>
      <label className='label cursor-pointer '>
        <span className='label-text'>自動計測</span>
        <input
          {...register('pcKoubouCrawlSetting.enabled')}
          type='checkbox'
          className='toggle toggle-primary'
        />
      </label>
    </>
  )
}

export default PcKoubouForm
