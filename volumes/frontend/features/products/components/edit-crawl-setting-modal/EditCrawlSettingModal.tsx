'use client'

import { useState } from 'react'

import { usePathname, useRouter, useSearchParams } from 'next/navigation'
import { Join } from 'react-daisyui'
import { useForm, SubmitHandler } from 'react-hook-form'
import { toast } from 'react-toastify'

import {
  useEditCrawlSettingModalState,
  useEditCrawlSettingModalQuery,
} from '../../hooks/useEditCrawlSettingModalState'
import { updateProduct } from '../../server-actions/productQuery'

import YahooAuctionForm from './YahooAuctionForm'

import { UpdateProductInput } from '@/graphql/dist/client'

const EditCrawlSettingModal = ({
  productId,
  defaultValues,
}: {
  productId: string | undefined
  defaultValues: UpdateProductInput
}) => {
  const router = useRouter()
  const pathname = usePathname()
  const searchParams = useSearchParams()
  const urlSearchParams = new URLSearchParams(searchParams)

  const [tab, setTab] = useState<'ヤフオク' | 'メルカリ' | 'ペイペイ'>('ヤフオク')
  const [modal, setModal] = useEditCrawlSettingModalState()

  const closeModal = () => {
    setModal(false)
    urlSearchParams.set(useEditCrawlSettingModalQuery, 'false')
    router.replace(`${pathname}?${urlSearchParams.toString()}`)
  }

  const { register, handleSubmit } = useForm<UpdateProductInput>({
    defaultValues: {
      name: defaultValues?.name,
      yahoo_auction_crawl_setting: {
        keyword: defaultValues?.yahoo_auction_crawl_setting?.keyword,
        category_id: defaultValues?.yahoo_auction_crawl_setting?.category_id,
        min_price: defaultValues?.yahoo_auction_crawl_setting?.min_price,
        max_price: defaultValues?.yahoo_auction_crawl_setting?.max_price,
        enabled: defaultValues?.yahoo_auction_crawl_setting?.enabled,
      },
    },
    values: defaultValues,
  })

  const onSubmit: SubmitHandler<UpdateProductInput> = async (input) => {
    if (productId === undefined) {
      return toast.error('更新対象が見つかりませんでした。')
    }

    const result = await updateProduct(productId || '', input)

    if (result.data?.updateProduct.ok) {
      toast.success('success')
      closeModal()
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
        <div className='modal-box h-3/4 md:h-1/2'>
          <div
            onClick={closeModal}
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
                aria-label='ペイペイ'
                checked={tab == 'ペイペイ'}
                onChange={() => setTab('ペイペイ')}
              />
            </Join>
            <div>
              {tab == 'ヤフオク' && (
                <div className='py-4'>
                  <YahooAuctionForm register={register} />
                </div>
              )}
              {tab == 'メルカリ' && <div>メルカリ</div>}
              {tab == 'ペイペイ' && <div>ペイペイ</div>}
            </div>
            <button type='submit' className='btn btn-primary w-full'>
              更新
            </button>
          </form>
        </div>
        <div onClick={closeModal} className='modal-backdrop' />
      </div>
    </>
  )
}

export default EditCrawlSettingModal
