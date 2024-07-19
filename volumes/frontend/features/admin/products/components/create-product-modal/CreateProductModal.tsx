'use client'

import { useState } from 'react'

import { useRouter } from 'next/navigation'
import { Join } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { createProduct } from '../../../../../server-actions/productQuery'
import { useCreateProductModalState } from '../../hooks/useCreateProductModalState'

import IosysForm from './IosysForm'
import JanparaForm from './JanparaForm'
import MercariForm from './MercariForm'
import PcKoubouForm from './PcKoubouForm'
import UsedSofmapForm from './UsedSofmapForm'
import YahooAuctionForm from './YahooAuctionForm'

import type { CreateProductInput, AdminProductsPageDataQuery } from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

export type reflectValueType = (
  source: 'yahooAuction' | 'mercari' | 'janpara' | 'iosys' | 'pcKoubou' | 'usedSofmap',
  property: 'keyword' | 'minPrice' | 'maxPrice',
) => void

const CreateProductModal = ({
  defaultValues,
  categories,
}: {
  defaultValues: CreateProductInput | undefined
  categories: AdminProductsPageDataQuery['categories'] | undefined
}) => {
  const router = useRouter()

  const [modal, setModal] = useCreateProductModalState()
  const [tab, setTab] = useState<
    'ヤフオク' | 'メルカリ' | 'じゃんぱら' | 'イオシス' | 'パソコン工房' | 'リコレ'
  >('ヤフオク')

  const { register, handleSubmit, setValue, getValues } = useForm<CreateProductInput>({
    defaultValues: {
      name: defaultValues?.name || '',
      categoryId: defaultValues?.categoryId || '',
      yahooAuctionCrawlSetting: {
        keyword: defaultValues?.yahooAuctionCrawlSetting?.keyword || '',
        categoryId: defaultValues?.yahooAuctionCrawlSetting?.categoryId || null,
        minPrice: defaultValues?.yahooAuctionCrawlSetting?.minPrice || 0,
        maxPrice: defaultValues?.yahooAuctionCrawlSetting?.maxPrice || 0,
        enabled: defaultValues?.yahooAuctionCrawlSetting?.enabled || true,
      },
      mercariCrawlSetting: {
        keyword: defaultValues?.mercariCrawlSetting?.keyword || '',
        categoryId: defaultValues?.mercariCrawlSetting?.categoryId || null,
        minPrice: defaultValues?.mercariCrawlSetting?.minPrice || 0,
        maxPrice: defaultValues?.mercariCrawlSetting?.maxPrice || 0,
        enabled: defaultValues?.mercariCrawlSetting?.enabled || true,
      },
      janparaCrawlSetting: {
        keyword: defaultValues?.janparaCrawlSetting?.keyword || '',
        minPrice: defaultValues?.janparaCrawlSetting?.minPrice || 0,
        maxPrice: defaultValues?.janparaCrawlSetting?.maxPrice || 0,
        enabled: defaultValues?.janparaCrawlSetting?.enabled || true,
      },
      iosysCrawlSetting: {
        keyword: defaultValues?.iosysCrawlSetting?.keyword || '',
        minPrice: defaultValues?.iosysCrawlSetting?.minPrice || 0,
        maxPrice: defaultValues?.iosysCrawlSetting?.maxPrice || 0,
        enabled: defaultValues?.iosysCrawlSetting?.enabled || true,
      },
      pcKoubouCrawlSetting: {
        keyword: defaultValues?.pcKoubouCrawlSetting?.keyword || '',
        minPrice: defaultValues?.pcKoubouCrawlSetting?.minPrice || 0,
        maxPrice: defaultValues?.pcKoubouCrawlSetting?.maxPrice || 0,
        enabled: defaultValues?.pcKoubouCrawlSetting?.enabled || true,
      },
      usedSofmapCrawlSetting: {
        keyword: defaultValues?.usedSofmapCrawlSetting?.keyword || '',
        minPrice: defaultValues?.usedSofmapCrawlSetting?.minPrice || 0,
        maxPrice: defaultValues?.usedSofmapCrawlSetting?.maxPrice || 0,
        enabled: defaultValues?.usedSofmapCrawlSetting?.enabled || true,
      },
    },
    values: defaultValues,
  })

  const onSubmit: SubmitHandler<CreateProductInput> = async (data) => {
    const result = await createProduct(data)

    if (result.data?.createProduct.ok) {
      toast.success('success')
      setModal(false)
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  const reflectValue: reflectValueType = (
    source: 'yahooAuction' | 'mercari' | 'janpara' | 'iosys' | 'pcKoubou' | 'usedSofmap',
    property: 'keyword' | 'minPrice' | 'maxPrice',
  ) => {
    const value = getValues(`${source}CrawlSetting.${property}`)
    setValue(`yahooAuctionCrawlSetting.${property}`, value)
    setValue(`mercariCrawlSetting.${property}`, value)
    setValue(`janparaCrawlSetting.${property}`, value)
    setValue(`iosysCrawlSetting.${property}`, value)
    setValue(`pcKoubouCrawlSetting.${property}`, value)
    setValue(`usedSofmapCrawlSetting.${property}`, value)
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
          <h3 className='text-lg font-bold'>計測設定を追加</h3>
          <form onSubmit={handleSubmit(onSubmit)}>
            <div className='divider py-2'>共通設定</div>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>管理コード</span>
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
            <div className='divider py-6'>詳細設定</div>
            <Join className='flex pb-2'>
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='ヤフオク'
                defaultChecked={tab === null || tab === 'ヤフオク'}
                onClick={() => setTab('ヤフオク')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='メルカリ'
                defaultChecked={tab === 'メルカリ'}
                onClick={() => setTab('メルカリ')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='じゃんぱら'
                defaultChecked={tab === 'じゃんぱら'}
                onClick={() => setTab('じゃんぱら')}
              />
            </Join>
            <Join className='flex'>
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='イオシス'
                defaultChecked={tab === 'イオシス'}
                onClick={() => setTab('イオシス')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='パソコン工房'
                defaultChecked={tab === 'パソコン工房'}
                onClick={() => setTab('パソコン工房')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='リコレ'
                defaultChecked={tab === 'リコレ'}
                onClick={() => setTab('リコレ')}
              />
            </Join>
            <div>
              {(tab === null || tab === 'ヤフオク') && (
                <div className='py-4'>
                  <YahooAuctionForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab === 'メルカリ' && (
                <div className='py-4'>
                  <MercariForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab === 'じゃんぱら' && (
                <div className='py-4'>
                  <JanparaForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab === 'イオシス' && (
                <div className='py-4'>
                  <IosysForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab === 'パソコン工房' && (
                <div className='py-4'>
                  <PcKoubouForm register={register} reflectValue={reflectValue} />
                </div>
              )}
              {tab === 'リコレ' && (
                <div className='py-4'>
                  <UsedSofmapForm register={register} reflectValue={reflectValue} />
                </div>
              )}
            </div>
            <button type='submit' className='btn btn-primary w-full'>
              登録
            </button>
          </form>
        </div>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default CreateProductModal
