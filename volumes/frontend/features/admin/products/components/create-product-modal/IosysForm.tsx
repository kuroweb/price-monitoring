'use client'

import type { reflectValueType } from './CreateProductModal'
import type { CreateProductInput } from '@/graphql/dist/client'
import type { useForm } from 'react-hook-form'

const IosysForm = ({
  register,
  reflectValue,
}: {
  register: ReturnType<typeof useForm<CreateProductInput>>['register']
  reflectValue: reflectValueType
}) => {
  return (
    <>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>計測キーワード</span>
        </div>
        <input {...register('iosysCrawlSetting.keyword')} className='input input-bordered' />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('iosys', 'keyword')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最低価格</span>
        </div>
        <input
          {...register('iosysCrawlSetting.minPrice', { valueAsNumber: true })}
          className='input input-bordered'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('iosys', 'minPrice')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最高価格</span>
        </div>
        <input
          {...register('iosysCrawlSetting.maxPrice', { valueAsNumber: true })}
          className='input input-bordered'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('iosys', 'maxPrice')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='label cursor-pointer'>
        <span className='label-text'>自動計測</span>
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
