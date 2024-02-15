'use client'

import { useRouter } from 'next/navigation'
import { useForm, SubmitHandler } from 'react-hook-form'
import { toast } from 'react-toastify'

import { createProduct } from '../server-actions/product-query'

import { CreateProductInput } from '@/graphql/dist/client'

const CreateForm = () => {
  const router = useRouter()

  const { register, handleSubmit } = useForm<CreateProductInput>({
    defaultValues: {
      name: '',
      yahoo_auction_crawl_setting: {
        keyword: '',
        category_id: undefined,
        min_price: 0,
        max_price: 0,
        enabled: true,
      },
    },
  })

  const onSubmit: SubmitHandler<CreateProductInput> = async (data) => {
    const result = await createProduct(data)

    if (result.data?.createProduct.ok) {
      toast.success('success')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} className='w-full space-y-2'>
      <div className='divider py-6'>共通設定</div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>管理コード</span>
        </div>
        <input {...register('name')} className='input input-bordered' />
      </label>
      <div className='divider py-6'>ヤフオク設定</div>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>計測キーワード</span>
        </div>
        <input
          {...register('yahoo_auction_crawl_setting.keyword')}
          className='input input-bordered'
        />
      </label>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>カテゴリID</span>
        </div>
        <input
          {...register('yahoo_auction_crawl_setting.category_id')}
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
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最高価格</span>
        </div>
        <input
          {...register('yahoo_auction_crawl_setting.max_price')}
          className='input input-bordered'
        />
      </label>
      <label className='label cursor-pointer'>
        <span className='label-text'>自動計測</span>
        <input
          {...register('yahoo_auction_crawl_setting.enabled')}
          type='checkbox'
          className='toggle toggle-primary'
        />
      </label>
      <button
        type='submit'
        className='block mt-4 py-2 px-4 bg-blue-500 rounded-md hover:bg-blue-700'
      >
        登録
      </button>
    </form>
  )
}

export default CreateForm
