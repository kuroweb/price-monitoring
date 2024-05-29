import { useEffect, useState } from 'react'

import { Join } from 'react-daisyui'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'
import { useTypedFetcher } from 'remix-typedjson'

import { useCreateProductModalStore } from '../../stores/create-product-modal-store'

import IosysForm from './IosysForm'
import JanparaForm from './JanparaForm'
import MercariForm from './MercariForm'
import PcKoubouForm from './PcKoubouForm'
import YahooAuctionForm from './YahooAuctionForm'

import { action } from '@/app/routes/api.products._index'
import { CreateProductInput } from '@/graphql/dist/client'

const CreateCrawlSettingModal = () => {
  const { isOpen, close } = useCreateProductModalStore()

  const [tab, setTab] = useState<
    'ヤフオク' | 'メルカリ' | 'じゃんぱら' | 'イオシス' | 'パソコン工房'
  >('ヤフオク')

  const { register, handleSubmit, getValues, setValue } = useForm<CreateProductInput>({
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
      pc_koubou_crawl_setting: {
        keyword: '',
        min_price: 0,
        max_price: 0,
        enabled: true,
      },
    },
  })

  const fetcher = useTypedFetcher<typeof action>()

  useEffect(() => {
    const data = fetcher.data?.data
    if (!data) return

    if ('createProduct' in data && data.createProduct.ok) {
      toast.success('success')
      close()
    } else {
      console.log(data)
      toast.error('error')
    }
  }, [fetcher.data, close])

  const onSubmit: SubmitHandler<CreateProductInput> = async (input) => {
    fetcher.submit(
      { control: 'create', input: input },
      { action: '/api/products', method: 'post', encType: 'application/json' },
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
          <div
            onClick={() => close()}
            className='btn btn-sm btn-circle btn-ghost absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='font-bold text-lg'>計測設定を追加</h3>
          <form onSubmit={handleSubmit(onSubmit)} className='w-full space-y-2'>
            <div className='divider py-2'>共通設定</div>
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
                defaultChecked={tab === null || tab === 'ヤフオク'}
                onClick={() => setTab('ヤフオク')}
              />
              <input
                className='join-item btn btn-md w-1/5'
                type='radio'
                name='options'
                aria-label='メルカリ'
                defaultChecked={tab === 'メルカリ'}
                onClick={() => setTab('メルカリ')}
              />
              <input
                className='join-item btn btn-md w-1/5'
                type='radio'
                name='options'
                aria-label='じゃんぱら'
                defaultChecked={tab === 'じゃんぱら'}
                onClick={() => setTab('じゃんぱら')}
              />
              <input
                className='join-item btn btn-md w-1/5'
                type='radio'
                name='options'
                aria-label='イオシス'
                defaultChecked={tab === 'イオシス'}
                onClick={() => setTab('イオシス')}
              />
              <input
                className='join-item btn btn-md w-1/5'
                type='radio'
                name='options'
                aria-label='パソコン工房'
                defaultChecked={tab === 'パソコン工房'}
                onClick={() => setTab('パソコン工房')}
              />
            </Join>
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
            </div>
            <button type='submit' className='btn btn-primary w-full'>
              登録
            </button>
          </form>
        </div>
        <div onClick={() => close()} className='modal-backdrop' />
      </div>
    </>
  )
}

export default CreateCrawlSettingModal
