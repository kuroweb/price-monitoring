'use client'

import { useState } from 'react'

import { useRouter } from 'next/navigation'
import { Join } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useUpdateProductModalState } from '../../hooks/useUpdateProductModalState'

import IosysForm from './components/IosysForm'
import JanparaForm from './components/JanparaForm'
import MercariForm from './components/MercariForm'
import PcKoubouForm from './components/PcKoubouForm'
import UsedSofmapForm from './components/UsedSofmapForm'
import YahooAuctionForm from './components/YahooAuctionForm'

import type { Category, ProductDetail, UpdateProductData } from '@/api'
import type { SubmitHandler } from 'react-hook-form'

import { updateProduct } from '@/server-actions/api'

export type copyValueType = (
  source: 'yahooAuction' | 'mercari' | 'janpara' | 'iosys' | 'pcKoubou' | 'usedSofmap',
  property: 'keyword' | 'minPrice' | 'maxPrice',
) => void

const UpdateProductModal = ({
  productId,
  productDetail,
  categories,
}: {
  productId: number
  productDetail: ProductDetail | undefined
  categories: Category[]
}) => {
  const router = useRouter()

  type SectionTypes =
    | 'ヤフオク'
    | 'メルカリ'
    | 'じゃんぱら'
    | 'イオシス'
    | 'パソコン工房'
    | 'リコレ'

  const [tab, setTab] = useState<SectionTypes>('ヤフオク')
  const [modal, setModal] = useUpdateProductModalState()

  const defaultValues = {
    name: productDetail?.name || '',
    categoryId: productDetail?.category?.id || categories[0].id,
    yahooAuctionCrawlSetting: {
      keyword: productDetail?.yahooAuctionCrawlSetting?.keyword || '',
      categoryId: productDetail?.yahooAuctionCrawlSetting?.categoryId || null,
      minPrice: productDetail?.yahooAuctionCrawlSetting?.minPrice || 0,
      maxPrice: productDetail?.yahooAuctionCrawlSetting?.maxPrice || 0,
      enabled: productDetail?.yahooAuctionCrawlSetting?.enabled || true,
      yahooAuctionCrawlSettingExcludeKeywords:
        productDetail?.yahooAuctionCrawlSetting?.yahooAuctionCrawlSettingExcludeKeywords || [],
      yahooAuctionCrawlSettingRequiredKeywords:
        productDetail?.yahooAuctionCrawlSetting?.yahooAuctionCrawlSettingRequiredKeywords || [],
    },
    mercariCrawlSetting: {
      keyword: productDetail?.mercariCrawlSetting?.keyword || '',
      categoryId: productDetail?.mercariCrawlSetting?.categoryId || null,
      minPrice: productDetail?.mercariCrawlSetting?.minPrice || 0,
      maxPrice: productDetail?.mercariCrawlSetting?.maxPrice || 0,
      enabled: productDetail?.mercariCrawlSetting?.enabled || true,
      mercariCrawlSettingExcludeKeywords:
        productDetail?.mercariCrawlSetting?.mercariCrawlSettingExcludeKeywords || [],
      mercariCrawlSettingRequiredKeywords:
        productDetail?.mercariCrawlSetting?.mercariCrawlSettingRequiredKeywords || [],
    },
    janparaCrawlSetting: {
      keyword: productDetail?.janparaCrawlSetting?.keyword || '',
      minPrice: productDetail?.janparaCrawlSetting?.minPrice || 0,
      maxPrice: productDetail?.janparaCrawlSetting?.maxPrice || 0,
      enabled: productDetail?.janparaCrawlSetting?.enabled || true,
      janparaCrawlSettingExcludeKeywords:
        productDetail?.janparaCrawlSetting?.janparaCrawlSettingExcludeKeywords || [],
      janparaCrawlSettingRequiredKeywords:
        productDetail?.janparaCrawlSetting?.janparaCrawlSettingRequiredKeywords || [],
    },
    iosysCrawlSetting: {
      keyword: productDetail?.iosysCrawlSetting?.keyword || '',
      minPrice: productDetail?.iosysCrawlSetting?.minPrice || 0,
      maxPrice: productDetail?.iosysCrawlSetting?.maxPrice || 0,
      enabled: productDetail?.iosysCrawlSetting?.enabled || true,
      iosysCrawlSettingExcludeKeywords:
        productDetail?.iosysCrawlSetting?.iosysCrawlSettingExcludeKeywords || [],
      iosysCrawlSettingRequiredKeywords:
        productDetail?.iosysCrawlSetting?.iosysCrawlSettingRequiredKeywords || [],
    },
    pcKoubouCrawlSetting: {
      keyword: productDetail?.pcKoubouCrawlSetting?.keyword || '',
      minPrice: productDetail?.pcKoubouCrawlSetting?.minPrice || 0,
      maxPrice: productDetail?.pcKoubouCrawlSetting?.maxPrice || 0,
      enabled: productDetail?.pcKoubouCrawlSetting?.enabled || true,
      pcKoubouCrawlSettingExcludeKeywords:
        productDetail?.pcKoubouCrawlSetting?.pcKoubouCrawlSettingExcludeKeywords || [],
      pcKoubouCrawlSettingRequiredKeywords:
        productDetail?.pcKoubouCrawlSetting?.pcKoubouCrawlSettingRequiredKeywords || [],
    },
    usedSofmapCrawlSetting: {
      keyword: productDetail?.usedSofmapCrawlSetting?.keyword || '',
      minPrice: productDetail?.usedSofmapCrawlSetting?.minPrice || 0,
      maxPrice: productDetail?.usedSofmapCrawlSetting?.maxPrice || 0,
      enabled: productDetail?.usedSofmapCrawlSetting?.enabled || true,
      usedSofmapCrawlSettingExcludeKeywords:
        productDetail?.usedSofmapCrawlSetting?.usedSofmapCrawlSettingExcludeKeywords || [],
      usedSofmapCrawlSettingRequiredKeywords:
        productDetail?.usedSofmapCrawlSetting?.usedSofmapCrawlSettingRequiredKeywords || [],
    },
  }

  const { register, handleSubmit, getValues, setValue } = useForm<UpdateProductData>({
    defaultValues,
    values: defaultValues,
  })

  const onSubmit: SubmitHandler<UpdateProductData> = async (data) => {
    const res = await updateProduct(productId, data)

    if (res.status === 200) {
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
            <div className='divider pt-6'>管理情報</div>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>名称</span>
              </div>
              <input {...register('name')} className='input input-bordered' />
            </label>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>カテゴリ</span>
              </div>
              <select {...register('categoryId')} className='input input-bordered'>
                {categories?.map((category) => (
                  <option key={category.id} value={category.id}>
                    {category.name}
                  </option>
                ))}
              </select>
            </label>
            <div className='divider py-6'>計測条件</div>
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
              {tab == 'リコレ' && (
                <div className='py-4'>
                  <UsedSofmapForm register={register} getValues={getValues} setValue={setValue} />
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
