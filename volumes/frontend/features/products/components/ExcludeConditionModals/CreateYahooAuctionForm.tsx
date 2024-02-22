import { useCallback, useRef } from 'react'

import { useRouter } from 'next/navigation'
import { Button, Modal } from 'react-daisyui'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { CreateYahooAuctionCrawlSettingExcludeConditionInput } from '@/graphql/dist/client'

const CreateYahooAuctionForm = () => {
  const router = useRouter()
  const { register, handleSubmit } = useForm<CreateYahooAuctionCrawlSettingExcludeConditionInput>({
    defaultValues: {
      keyword: undefined,
      yahoo_auction_id: undefined,
      seller_id: undefined,
    },
  })

  const onSubmit: SubmitHandler<CreateYahooAuctionCrawlSettingExcludeConditionInput> = async (
    data,
  ) => {
    // TODO: Submit後にモーダルを閉じる。みたいなことがやりづらそう（調査中）
    // const result = await createProduct(data)
    // if (result.data?.createProduct.ok) {
    if (true) {
      toast.success('success')
      closeModal()
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  // モーダルの表示コントロール
  const ref = useRef<HTMLDialogElement>(null)
  const showModal = useCallback(() => {
    ref.current?.showModal()
  }, [ref])
  const closeModal = useCallback(() => {
    ref.current?.close()
  }, [ref])

  return (
    <>
      <form onSubmit={handleSubmit(onSubmit)} className='w-full space-y-2'>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>キーワード</span>
          </div>
          <input {...register('keyword')} className='input input-bordered' />
        </label>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>ヤフオクID</span>
          </div>
          <input {...register('yahoo_auction_id')} className='input input-bordered' />
        </label>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>出品者ID</span>
          </div>
          <input {...register('seller_id')} className='input input-bordered' />
        </label>
        <div className='pt-4'>
          <Button type='submit' color='primary' size='md' className='w-full'>
            追加
          </Button>
        </div>
      </form>
    </>
  )
}

export default CreateYahooAuctionForm
