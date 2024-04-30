'use client'

import { useState } from 'react'

import { useRouter } from 'next/navigation'
import { Join } from 'react-daisyui'
import { useForm, SubmitHandler } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useEditCrawlSettingModalState } from '../../hooks/useEditCrawlSettingModalState'
import { updateProduct } from '../../server-actions/productQuery'

import JanparaForm from './JanparaForm'
import MercariForm from './MercariForm'
import YahooAuctionForm from './YahooAuctionForm'

import { UpdateProductInput } from '@/graphql/dist/client'

const EditCrawlSettingModal = ({
  productId,
  defaultValues,
}: {
  productId: string | undefined
  defaultValues: UpdateProductInput | undefined
}) => {
  const router = useRouter()
  const [tab, setTab] = useState<'ヤフオク' | 'メルカリ' | 'じゃんぱら'>('ヤフオク')
  const [modal, setModal] = useEditCrawlSettingModalState()

  const { register, handleSubmit } = useForm<UpdateProductInput>({
    defaultValues: {
      name: defaultValues?.name || '',
      yahoo_auction_crawl_setting: {
        keyword: defaultValues?.yahoo_auction_crawl_setting?.keyword || '',
        category_id: defaultValues?.yahoo_auction_crawl_setting?.category_id || null,
        min_price: defaultValues?.yahoo_auction_crawl_setting?.min_price || 0,
        max_price: defaultValues?.yahoo_auction_crawl_setting?.max_price || 0,
        enabled: defaultValues?.yahoo_auction_crawl_setting?.enabled || false,
      },
      mercari_crawl_setting: {
        keyword: defaultValues?.mercari_crawl_setting?.keyword || '',
        category_id: defaultValues?.mercari_crawl_setting?.category_id || null,
        min_price: defaultValues?.mercari_crawl_setting?.min_price || 0,
        max_price: defaultValues?.mercari_crawl_setting?.max_price || 0,
        enabled: defaultValues?.mercari_crawl_setting?.enabled || false,
      },
      janpara_crawl_setting: {
        keyword: defaultValues?.janpara_crawl_setting?.keyword || '',
        min_price: defaultValues?.janpara_crawl_setting?.min_price || 0,
        max_price: defaultValues?.janpara_crawl_setting?.max_price || 0,
        enabled: defaultValues?.janpara_crawl_setting?.enabled || false,
      },
    },
    values: defaultValues,
  })

  const onSubmit: SubmitHandler<UpdateProductInput> = async (input) => {
    console.log(input)
    if (productId === undefined) {
      return toast.error('更新対象が見つかりませんでした。')
    }

    const result = await updateProduct(productId || '', input)

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
      <input
        type='checkbox'
        className='modal-toggle'
        checked={modal}
        onChange={(e) => setModal(e.target.checked)}
      />
      <div className='modal' role='dialog'>
        <div className='modal-box h-fit'>
          <div
            onClick={() => setModal(false)}
            className='btn btn-sm btn-circle btn-ghost absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='font-bold text-lg'>計測設定を更新</h3>
          <form onSubmit={handleSubmit(onSubmit)}>
            <div className='divider py-4'>共通設定</div>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>管理コード</span>
              </div>
              <input {...register('name')} className='input input-bordered' />
            </label>
            <div className='divider py-6'>詳細設定</div>
            <Join className='flex'>
              <input
                className='join-item btn btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='ヤフオク'
                checked={tab == 'ヤフオク'}
                onChange={() => setTab('ヤフオク')}
              />
              <input
                className='join-item btn btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='メルカリ'
                checked={tab == 'メルカリ'}
                onChange={() => setTab('メルカリ')}
              />
              <input
                className='join-item btn btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='じゃんぱら'
                checked={tab == 'じゃんぱら'}
                onChange={() => setTab('じゃんぱら')}
              />
            </Join>
            <div>
              {tab == 'ヤフオク' && (
                <div className='py-4'>
                  <YahooAuctionForm register={register} />
                </div>
              )}
              {tab == 'メルカリ' && (
                <div className='py-4'>
                  <MercariForm register={register} />
                </div>
              )}
              {tab == 'じゃんぱら' && (
                <div className='py-4'>
                  <JanparaForm register={register} />
                </div>
              )}
            </div>
            <button type='submit' className='btn btn-primary w-full'>
              更新
            </button>
          </form>
        </div>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default EditCrawlSettingModal
