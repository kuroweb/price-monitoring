'use client'

import { useEffect, useState } from 'react'

import { Join } from 'react-daisyui'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'
import { useTypedFetcher } from 'remix-typedjson'

import { action } from '../../../../app/routes/api.products.update'

import IosysForm from './IosysForm'
import JanparaForm from './JanparaForm'
import MercariForm from './MercariForm'
import PcKoubouForm from './PcKoubouForm'
import YahooAuctionForm from './YahooAuctionForm'

import { useEditCrawlSettingModalStore } from '@/features/products/stores/edit-crawl-setting-modal-store'
import { UpdateProductInput } from '@/graphql/dist/client'

const EditCrawlSettingModal = ({
  productId,
  defaultValues,
}: {
  productId: string | undefined
  defaultValues: UpdateProductInput | undefined
}) => {
  const [tab, setTab] = useState<
    'ヤフオク' | 'メルカリ' | 'じゃんぱら' | 'イオシス' | 'パソコン工房'
  >('ヤフオク')

  const { isOpen, close } = useEditCrawlSettingModalStore()

  const { register, handleSubmit, getValues, setValue } = useForm<UpdateProductInput>({
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
      iosys_crawl_setting: {
        keyword: defaultValues?.iosys_crawl_setting?.keyword || '',
        min_price: defaultValues?.iosys_crawl_setting?.min_price || 0,
        max_price: defaultValues?.iosys_crawl_setting?.max_price || 0,
        enabled: defaultValues?.iosys_crawl_setting?.enabled || false,
      },
      pc_koubou_crawl_setting: {
        keyword: defaultValues?.pc_koubou_crawl_setting?.keyword || '',
        min_price: defaultValues?.pc_koubou_crawl_setting?.min_price || 0,
        max_price: defaultValues?.pc_koubou_crawl_setting?.max_price || 0,
        enabled: defaultValues?.pc_koubou_crawl_setting?.enabled || false,
      },
    },
    values: defaultValues,
  })

  const fetcher = useTypedFetcher<typeof action>()

  useEffect(() => {
    const data = fetcher.data?.data
    if (!data) return

    if (data.updateProduct.ok) {
      toast.success('success')
      close()
    } else {
      toast.error('error')
    }
  }, [fetcher.data, close])

  const onSubmit: SubmitHandler<UpdateProductInput> = async (input) => {
    if (productId === undefined) {
      return toast.error('更新対象が見つかりませんでした。')
    }

    fetcher.submit(
      { productId: productId, input: input },
      { action: '/api/products/update', method: 'post', encType: 'application/json' },
    )
  }

  return (
    <>
      <input
        type='checkbox'
        className='modal-toggle'
        checked={isOpen}
        onChange={(e) => (e.target.checked ? open() : close())}
      />
      <div className='modal' role='dialog'>
        <div className='modal-box h-fit'>
          <button
            onClick={() => close()}
            className='btn btn-sm btn-circle btn-ghost absolute right-4 top-4'
          >
            ✕
          </button>
          <h3 className='font-bold text-lg'>計測設定を更新</h3>
          <form onSubmit={handleSubmit(onSubmit)}>
            <input name='productId' defaultValue={productId} hidden />
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
                className='join-item btn btn-md w-1/5'
                type='radio'
                name='options'
                aria-label='ヤフオク'
                checked={tab == 'ヤフオク'}
                onChange={() => setTab('ヤフオク')}
              />
              <input
                className='join-item btn btn-md w-1/5'
                type='radio'
                name='options'
                aria-label='メルカリ'
                checked={tab == 'メルカリ'}
                onChange={() => setTab('メルカリ')}
              />
              <input
                className='join-item btn btn-md w-1/5'
                type='radio'
                name='options'
                aria-label='じゃんぱら'
                checked={tab == 'じゃんぱら'}
                onChange={() => setTab('じゃんぱら')}
              />
              <input
                className='join-item btn btn-md w-1/5'
                type='radio'
                name='options'
                aria-label='イオシス'
                checked={tab == 'イオシス'}
                onChange={() => setTab('イオシス')}
              />
              <input
                className='join-item btn btn-md w-1/5'
                type='radio'
                name='options'
                aria-label='パソコン工房'
                checked={tab == 'パソコン工房'}
                onChange={() => setTab('パソコン工房')}
              />
            </Join>
            <div>
              {tab == 'ヤフオク' && (
                <div className='py-4'>
                  <YahooAuctionForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
              {tab == 'メルカリ' && (
                <div className='py-4'>
                  <MercariForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
              {tab == 'じゃんぱら' && (
                <div className='py-4'>
                  <JanparaForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
              {tab == 'イオシス' && (
                <div className='py-4'>
                  <IosysForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
              {tab == 'パソコン工房' && (
                <div className='py-4'>
                  <PcKoubouForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
            </div>
            <button type='submit' className='btn btn-primary w-full'>
              更新
            </button>
          </form>
        </div>
        <button onClick={() => close()} className='modal-backdrop' />
      </div>
    </>
  )
}

export default EditCrawlSettingModal
