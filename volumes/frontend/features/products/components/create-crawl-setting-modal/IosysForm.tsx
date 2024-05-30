'use client'

import type { CreateProductInput } from '@/graphql/dist/client'
import type { useForm } from 'react-hook-form'

const IosysForm = ({
  register,
  getValues,
  setValue,
}: {
  register: ReturnType<typeof useForm<CreateProductInput>>['register']
  getValues: ReturnType<typeof useForm<CreateProductInput>>['getValues']
  setValue: ReturnType<typeof useForm<CreateProductInput>>['setValue']
}) => {
  const reflectValue = (property: 'keyword' | 'min_price' | 'max_price') => {
    const value = getValues(`iosys_crawl_setting.${property}`)
    setValue(`yahoo_auction_crawl_setting.${property}`, value)
    setValue(`mercari_crawl_setting.${property}`, value)
    setValue(`janpara_crawl_setting.${property}`, value)
    setValue(`pc_koubou_crawl_setting.${property}`, value)
  }

  return (
    <>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>計測キーワード</span>
        </div>
        <input {...register('iosys_crawl_setting.keyword')} className='input input-bordered' />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('keyword')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最低価格</span>
        </div>
        <input {...register('iosys_crawl_setting.min_price')} className='input input-bordered' />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('min_price')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最高価格</span>
        </div>
        <input {...register('iosys_crawl_setting.max_price')} className='input input-bordered' />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('max_price')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='label cursor-pointer'>
        <span className='label-text'>自動計測</span>
        <input
          {...register('iosys_crawl_setting.enabled')}
          type='checkbox'
          className='toggle toggle-primary'
        />
      </label>
    </>
  )
}

export default IosysForm
