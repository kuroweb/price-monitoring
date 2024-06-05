'use client'

import { useState } from 'react'

import { usePathname, useRouter } from 'next/navigation'
import { Join } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useUpdateProductModalState } from '../../hooks/useUpdateProductModalState'
import { updateProduct } from '../../server-actions/graphql/productQuery'

import IosysForm from './IosysForm'
import JanparaForm from './JanparaForm'
import MercariForm from './MercariForm'
import PcKoubouForm from './PcKoubouForm'
import UsedSofmapForm from './UsedSofmapForm'
import YahooAuctionForm from './YahooAuctionForm'

import type { UpdateProductInput } from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

export type reflectValueType = (
  source: 'yahoo_auction' | 'mercari' | 'janpara' | 'iosys' | 'pc_koubou' | 'used_sofmap',
  property: 'keyword' | 'min_price' | 'max_price',
) => void

const UpdateProductModal = ({
  productId,
  defaultValues,
}: {
  productId: string | undefined
  defaultValues: UpdateProductInput | undefined
}) => {
  const router = useRouter()
  const pathname = usePathname()

  const [tab, setTab] = useState<
    'ヤフオク' | 'メルカリ' | 'じゃんぱら' | 'イオシス' | 'パソコン工房' | 'リコレ'
  >('ヤフオク')
  const [modal, setModal] = useUpdateProductModalState()

  const reflectValue: reflectValueType = (
    source: 'yahoo_auction' | 'mercari' | 'janpara' | 'iosys' | 'pc_koubou' | 'used_sofmap',
    property: 'keyword' | 'min_price' | 'max_price',
  ) => {
    const value = getValues(`${source}_crawl_setting.${property}`)
    setValue(`yahoo_auction_crawl_setting.${property}`, value)
    setValue(`mercari_crawl_setting.${property}`, value)
    setValue(`janpara_crawl_setting.${property}`, value)
    setValue(`iosys_crawl_setting.${property}`, value)
    setValue(`pc_koubou_crawl_setting.${property}`, value)
    setValue(`used_sofmap_crawl_setting.${property}`, value)
  }

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
      used_sofmap_crawl_setting: {
        keyword: defaultValues?.used_sofmap_crawl_setting?.keyword || '',
        min_price: defaultValues?.used_sofmap_crawl_setting?.min_price || 0,
        max_price: defaultValues?.used_sofmap_crawl_setting?.max_price || 0,
        enabled: defaultValues?.used_sofmap_crawl_setting?.enabled || false,
      },
    },
    values: defaultValues,
  })

  const onSubmit: SubmitHandler<UpdateProductInput> = async (input) => {
    if (productId === undefined) {
      return toast.error('更新対象が見つかりませんでした。')
    }

    const result = await updateProduct(productId, input)

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
            className='btn btn-circle btn-ghost btn-sm absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='text-lg font-bold'>計測設定を更新</h3>
          <form onSubmit={handleSubmit(onSubmit)}>
            <div className='divider py-4'>共通設定</div>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>管理コード</span>
              </div>
              <input {...register('name')} className='input input-bordered' />
            </label>
            <div className='divider py-6'>詳細設定</div>
            <Join className='flex pb-2'>
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='ヤフオク'
                checked={tab == 'ヤフオク'}
                onChange={() => setTab('ヤフオク')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='メルカリ'
                checked={tab == 'メルカリ'}
                onChange={() => setTab('メルカリ')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='じゃんぱら'
                checked={tab == 'じゃんぱら'}
                onChange={() => setTab('じゃんぱら')}
              />
            </Join>
            <Join className='flex'>
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='イオシス'
                checked={tab == 'イオシス'}
                onChange={() => setTab('イオシス')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='パソコン工房'
                checked={tab == 'パソコン工房'}
                onChange={() => setTab('パソコン工房')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='リコレ'
                checked={tab == 'リコレ'}
                onChange={() => setTab('リコレ')}
              />
            </Join>
            <div>
              {tab == 'ヤフオク' && (
                <div className='py-4'>
                  <YahooAuctionForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab == 'メルカリ' && (
                <div className='py-4'>
                  <MercariForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab == 'じゃんぱら' && (
                <div className='py-4'>
                  <JanparaForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab == 'イオシス' && (
                <div className='py-4'>
                  <IosysForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab == 'パソコン工房' && (
                <div className='py-4'>
                  <PcKoubouForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab == 'リコレ' && (
                <div className='py-4'>
                  <UsedSofmapForm register={register} reflectValue={reflectValue} />
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

export default UpdateProductModal
