'use client'

import type { reflectValueType } from './CreateProductModal'
import type { CreateProductInput } from '@/graphql/dist/client'
import type { useForm } from 'react-hook-form'

const MercariForm = ({
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
        <input {...register('mercariCrawlSetting.keyword')} className='input input-bordered' />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('mercari', 'keyword')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>カテゴリID</span>
        </div>
        <input
          {...register('mercariCrawlSetting.categoryId', {
            setValueAs: (v) => (v === '' ? null : v),
            valueAsNumber: true,
          })}
          className='input input-bordered'
        />
      </label>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最低価格</span>
        </div>
        <input
          {...register('mercariCrawlSetting.minPrice', { valueAsNumber: true })}
          className='input input-bordered'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('mercari', 'minPrice')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最高価格</span>
        </div>
        <input
          {...register('mercariCrawlSetting.maxPrice', { valueAsNumber: true })}
          className='input input-bordered'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('mercari', 'maxPrice')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='label cursor-pointer'>
        <span className='label-text'>自動計測</span>
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
