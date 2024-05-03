'use client'

import { useRouter } from 'next/navigation'
import { useQueryState } from 'nuqs'
import { Join } from 'react-daisyui'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useCreateCrawlSettingModalState } from '../../hooks/useCreateCrawlSettingModalState'
import { createProduct } from '../../server-actions/productQuery'

import IosysForm from './IosysForm'
import JanparaForm from './JanparaForm'
import MercariForm from './MercariForm'
import YahooAuctionForm from './YahooAuctionForm'

import { CreateProductInput } from '@/graphql/dist/client'

const CreateCrawlSettingModal = () => {
  const router = useRouter()
  const [modal, setModal] = useCreateCrawlSettingModalState()
  const [tab, setTab] = useQueryState('create_crawl_setting_tab')

  const { register, handleSubmit } = useForm<CreateProductInput>({
    defaultValues: {
      name: '',
      yahoo_auction_crawl_setting: {
        keyword: '',
        category_id: null,
        min_price: 0,
        max_price: 0,
        enabled: true,
      },
      mercari_crawl_setting: {
        keyword: '',
        category_id: null,
        min_price: 0,
        max_price: 0,
        enabled: true,
      },
      janpara_crawl_setting: {
        keyword: '',
        min_price: 0,
        max_price: 0,
        enabled: true,
      },
      iosys_crawl_setting: {
        keyword: '',
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
          <h3 className='font-bold text-lg'>計測設定を追加</h3>
          <form onSubmit={handleSubmit(onSubmit)} className='w-full space-y-2'>
            <div className='divider py-4'>共通設定</div>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>管理コード</span>
              </div>
              <input {...register('name')} className='input input-bordered' />
            </label>
            <div className='divider py-8'>詳細設定</div>
            <Join className='flex'>
              <input
                className='join-item btn btn-md w-1/4'
                type='radio'
                name='options'
                aria-label='ヤフオク'
                defaultChecked={tab === null || tab === 'ヤフオク'}
                onClick={() => setTab('ヤフオク')}
              />
              <input
                className='join-item btn btn-md w-1/4'
                type='radio'
                name='options'
                aria-label='メルカリ'
                defaultChecked={tab === 'メルカリ'}
                onClick={() => setTab('メルカリ')}
              />
              <input
                className='join-item btn btn-md w-1/4'
                type='radio'
                name='options'
                aria-label='じゃんぱら'
                defaultChecked={tab === 'じゃんぱら'}
                onClick={() => setTab('じゃんぱら')}
              />
              <input
                className='join-item btn btn-md w-1/4'
                type='radio'
                name='options'
                aria-label='イオシス'
                defaultChecked={tab === 'イオシス'}
                onClick={() => setTab('イオシス')}
              />
            </Join>
            <div>
              {(tab === null || tab === 'ヤフオク') && (
                <div className='py-4'>
                  <YahooAuctionForm register={register} />
                </div>
              )}
              {tab === 'メルカリ' && (
                <div className='py-4'>
                  <MercariForm register={register} />
                </div>
              )}
              {tab === 'じゃんぱら' && (
                <div className='py-4'>
                  <JanparaForm register={register} />
                </div>
              )}
              {tab === 'イオシス' && (
                <div className='py-4'>
                  <IosysForm register={register} />
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

export default CreateCrawlSettingModal
