'use client'

import type { reflectValueType } from './UpdateProductModal'
import type { UpdateProductInput } from '@/graphql/dist/client'
import type { useForm } from 'react-hook-form'

const YahooAuctionForm = ({
  register,
  reflectValue,
}: {
  register: ReturnType<typeof useForm<UpdateProductInput>>['register']
  reflectValue: reflectValueType
}) => {
  return (
    <>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>計測キーワード</span>
        </div>
        <input
          {...register('yahoo_auction_crawl_setting.keyword')}
          className='input input-bordered'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('yahoo_auction', 'keyword')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>カテゴリID</span>
        </div>
        <input
          {...register('yahoo_auction_crawl_setting.category_id', {
            setValueAs: (v) => (v === '' ? null : v),
          })}
          className='input input-bordered'
        />
      </label>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最低価格</span>
        </div>
        <input
          {...register('yahoo_auction_crawl_setting.min_price')}
          className='input input-bordered'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('yahoo_auction', 'min_price')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最高価格</span>
        </div>
        <input
          {...register('yahoo_auction_crawl_setting.max_price')}
          className='input input-bordered'
        />
      </label>
      <div className='flex flex-row justify-end'>
        <button
          className='btn btn-link btn-xs'
          type='button'
          onClick={() => reflectValue('yahoo_auction', 'max_price')}
        >
          他のプラットフォームに反映
        </button>
      </div>
      <label className='label cursor-pointer '>
        <span className='label-text'>自動計測</span>
        <input
          {...register('yahoo_auction_crawl_setting.enabled')}
          type='checkbox'
          className='toggle toggle-primary'
        />
      </label>
    </>
  )
}

export default YahooAuctionForm
