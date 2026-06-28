'use client'

import { useState } from 'react'

import { useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import IosysForm from './IosysForm'
import JanparaForm from './JanparaForm'
import MercariForm from './MercariForm'
import PcKoubouForm from './PcKoubouForm'
import UsedSofmapForm from './UsedSofmapForm'
import YahooAuctionForm from './YahooAuctionForm'
import { useCreateProductModalState } from './hooks/useCreateProductModalState'

import type { Category, CreateProductData, ProductList } from '@/lib/api'
import type { SubmitHandler } from 'react-hook-form'

import {
  ScrollableModalBody,
  ScrollableModalBox,
  ScrollableModalFooter,
  ScrollableModalForm,
} from '@/components/ui/ScrollableModalBox'
import { createProduct } from '@/lib/actions'

const CreateProductModal = ({
  product,
  categories,
}: {
  product: ProductList['products'][number] | undefined
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
  const [modal, setModal] = useCreateProductModalState()

  const defaultValues = {
    name: product?.name || '',
    categoryId: product?.category?.id || categories[0]?.id || null,
    yahooAuctionCrawlSetting: {
      keyword: product?.yahooAuctionCrawlSetting?.keyword || '',
      categoryId: product?.yahooAuctionCrawlSetting?.categoryId || null,
      minPrice: product?.yahooAuctionCrawlSetting?.minPrice ?? 0,
      maxPrice: product?.yahooAuctionCrawlSetting?.maxPrice ?? 0,
      enabled: product?.yahooAuctionCrawlSetting?.enabled ?? true,
      yahooAuctionCrawlSettingExcludeKeywords:
        product?.yahooAuctionCrawlSetting?.yahooAuctionCrawlSettingExcludeKeywords ?? [],
      yahooAuctionCrawlSettingRequiredKeywords:
        product?.yahooAuctionCrawlSetting?.yahooAuctionCrawlSettingRequiredKeywords ?? [],
    },
    mercariCrawlSetting: {
      keyword: product?.mercariCrawlSetting?.keyword ?? '',
      categoryId: product?.mercariCrawlSetting?.categoryId ?? null,
      minPrice: product?.mercariCrawlSetting?.minPrice ?? 0,
      maxPrice: product?.mercariCrawlSetting?.maxPrice ?? 0,
      enabled: product?.mercariCrawlSetting?.enabled ?? true,
      mercariCrawlSettingExcludeKeywords:
        product?.mercariCrawlSetting?.mercariCrawlSettingExcludeKeywords ?? [],
      mercariCrawlSettingRequiredKeywords:
        product?.mercariCrawlSetting?.mercariCrawlSettingRequiredKeywords ?? [],
    },
    janparaCrawlSetting: {
      keyword: product?.janparaCrawlSetting?.keyword ?? '',
      minPrice: product?.janparaCrawlSetting?.minPrice ?? 0,
      maxPrice: product?.janparaCrawlSetting?.maxPrice ?? 0,
      enabled: product?.janparaCrawlSetting?.enabled ?? true,
      janparaCrawlSettingExcludeKeywords:
        product?.janparaCrawlSetting?.janparaCrawlSettingExcludeKeywords ?? [],
      janparaCrawlSettingRequiredKeywords:
        product?.janparaCrawlSetting?.janparaCrawlSettingRequiredKeywords ?? [],
    },
    iosysCrawlSetting: {
      keyword: product?.iosysCrawlSetting?.keyword ?? '',
      minPrice: product?.iosysCrawlSetting?.minPrice ?? 0,
      maxPrice: product?.iosysCrawlSetting?.maxPrice ?? 0,
      enabled: product?.iosysCrawlSetting?.enabled ?? true,
      iosysCrawlSettingExcludeKeywords:
        product?.iosysCrawlSetting?.iosysCrawlSettingExcludeKeywords ?? [],
      iosysCrawlSettingRequiredKeywords:
        product?.iosysCrawlSetting?.iosysCrawlSettingRequiredKeywords ?? [],
    },
    pcKoubouCrawlSetting: {
      keyword: product?.pcKoubouCrawlSetting?.keyword ?? '',
      minPrice: product?.pcKoubouCrawlSetting?.minPrice ?? 0,
      maxPrice: product?.pcKoubouCrawlSetting?.maxPrice ?? 0,
      enabled: product?.pcKoubouCrawlSetting?.enabled ?? true,
      pcKoubouCrawlSettingExcludeKeywords:
        product?.pcKoubouCrawlSetting?.pcKoubouCrawlSettingExcludeKeywords ?? [],
      pcKoubouCrawlSettingRequiredKeywords:
        product?.pcKoubouCrawlSetting?.pcKoubouCrawlSettingRequiredKeywords ?? [],
    },
    usedSofmapCrawlSetting: {
      keyword: product?.usedSofmapCrawlSetting?.keyword ?? '',
      minPrice: product?.usedSofmapCrawlSetting?.minPrice ?? 0,
      maxPrice: product?.usedSofmapCrawlSetting?.maxPrice ?? 0,
      enabled: product?.usedSofmapCrawlSetting?.enabled ?? true,
      usedSofmapCrawlSettingExcludeKeywords:
        product?.usedSofmapCrawlSetting?.usedSofmapCrawlSettingExcludeKeywords ?? [],
      usedSofmapCrawlSettingRequiredKeywords:
        product?.usedSofmapCrawlSetting?.usedSofmapCrawlSettingRequiredKeywords ?? [],
    },
  }

  const { register, handleSubmit, getValues, setValue } = useForm<CreateProductData>({
    defaultValues,
    values: defaultValues,
  })

  const onSubmit: SubmitHandler<CreateProductData> = async (data) => {
    const res = await createProduct(data)

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
        <ScrollableModalBox title='計測設定を追加' onClose={() => setModal(false)}>
          <ScrollableModalForm onSubmit={handleSubmit(onSubmit)}>
            <ScrollableModalBody>
            <div className='divider py-2'>共通設定</div>
            <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>管理コード</legend>
              <input {...register('name')} className='input w-full' />
      </fieldset>
            <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>カテゴリ</legend>
              <select
                {...register('categoryId', {
                  setValueAs: (value) => (value === '' ? null : Number(value)),
                })}
                className='select w-full'
              >
                <option value=''>未設定</option>
                {categories?.map((category) => (
                  <option key={category.id} value={category.id}>
                    {category.name}
                  </option>
                ))}
              </select>
        </fieldset>
            <div className='divider py-6'>詳細設定</div>
            <div className='join flex w-full flex-wrap pb-2'>
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='ヤフオク'
                checked={tab === 'ヤフオク'}
                onChange={() => setTab('ヤフオク')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='メルカリ'
                checked={tab === 'メルカリ'}
                onChange={() => setTab('メルカリ')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='じゃんぱら'
                checked={tab === 'じゃんぱら'}
                onChange={() => setTab('じゃんぱら')}
              />
            </div>
            <div className='join flex w-full flex-wrap'>
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='イオシス'
                checked={tab === 'イオシス'}
                onChange={() => setTab('イオシス')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='パソコン工房'
                checked={tab === 'パソコン工房'}
                onChange={() => setTab('パソコン工房')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='リコレ'
                checked={tab === 'リコレ'}
                onChange={() => setTab('リコレ')}
              />
            </div>
            <div>
              {(tab === null || tab === 'ヤフオク') && (
                <div className='py-4'>
                  <YahooAuctionForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
              {tab === 'メルカリ' && (
                <div className='py-4'>
                  <MercariForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
              {tab === 'じゃんぱら' && (
                <div className='py-4'>
                  <JanparaForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
              {tab === 'イオシス' && (
                <div className='py-4'>
                  <IosysForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
              {tab === 'パソコン工房' && (
                <div className='py-4'>
                  <PcKoubouForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
              {tab === 'リコレ' && (
                <div className='py-4'>
                  <UsedSofmapForm register={register} getValues={getValues} setValue={setValue} />
                </div>
              )}
            </div>
            </ScrollableModalBody>
            <ScrollableModalFooter>
            <button type='submit' className='btn btn-primary w-full'>
              登録
            </button>
            </ScrollableModalFooter>
          </ScrollableModalForm>
        </ScrollableModalBox>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default CreateProductModal
