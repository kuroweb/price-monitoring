'use client'

import { useState } from 'react'

import { useRouter, useParams } from 'next/navigation'
import { Tabs } from 'react-daisyui'
import { useForm, SubmitHandler } from 'react-hook-form'
import { toast } from 'react-toastify'

import { updateProduct } from '../server-actions/product-query'

import { GetProductDetailPageDataQuery, UpdateProductInput } from '@/graphql/dist/client'

const UpdateFormModal = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const router = useRouter()
  const params = useParams()
  const [modal, setModal] = useState<boolean>(false)

  const { register, handleSubmit } = useForm<UpdateProductInput>({
    defaultValues: {
      name: data.product.name,
      yahoo_auction_crawl_setting: {
        keyword: data.product.yahooAuctionCrawlSetting.keyword,
        category_id: data.product.yahooAuctionCrawlSetting.categoryId,
        min_price: data.product.yahooAuctionCrawlSetting.minPrice,
        max_price: data.product.yahooAuctionCrawlSetting.maxPrice,
        enabled: data.product.yahooAuctionCrawlSetting.enabled,
      },
    },
  })

  const onSubmit: SubmitHandler<UpdateProductInput> = async (data) => {
    if (data.yahoo_auction_crawl_setting?.category_id == 0) {
      data.yahoo_auction_crawl_setting.category_id = null
    }

    const result = await updateProduct(String(params.id), data)

    if (result.data?.updateProduct.ok) {
      toast.success('success')
      setModal(false)
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  return (
    <>
      <div onClick={() => setModal(true)} className='btn no-animation'>
        計測設定を更新
      </div>
      <input
        type='checkbox'
        className='modal-toggle'
        checked={modal}
        onChange={(e) => setModal(e.target.checked)}
      />
      <div className='modal' role='dialog'>
        <div className='modal-box'>
          <div
            onClick={() => setModal(false)}
            className='btn btn-sm btn-circle btn-ghost absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='font-bold text-lg'>計測設定を更新</h3>
          <form onSubmit={handleSubmit(onSubmit)}>
            <div className='divider pt-6'>共通設定</div>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>管理コード</span>
              </div>
              <input {...register('name')} className='input input-bordered' />
            </label>
            <div className='divider py-6'>詳細設定</div>
            <Tabs className='tabs-boxed'>
              <Tabs.RadioTab
                name='update_form_modal'
                label='ヤフオク'
                contentClassName='p-4 space-y-4'
                defaultChecked={true}
              >
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
                <label className='label cursor-pointer '>
                  <span className='label-text'>自動計測</span>
                  <input
                    {...register('yahoo_auction_crawl_setting.enabled')}
                    type='checkbox'
                    className='toggle toggle-primary'
                  />
                </label>
              </Tabs.RadioTab>
              <Tabs.RadioTab name='update_form_modal' label='メルカリ' contentClassName='p-10'>
                Tab content 2
              </Tabs.RadioTab>
              <Tabs.RadioTab name='update_form_modal' label='ペイペイ' contentClassName='p-10'>
                Tab content 3
              </Tabs.RadioTab>
            </Tabs>
            <button
              type='submit'
              className='block w-full mt-6 py-2 px-4 bg-blue-500 text-white rounded-md hover:bg-blue-700'
            >
              更新
            </button>
          </form>
        </div>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default UpdateFormModal
