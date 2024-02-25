'use client'

import { Dispatch, SetStateAction } from 'react'

import { useParams, useRouter } from 'next/dist/client/components/navigation'
import { Button } from 'react-daisyui'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { updateYahooAuctionCrawlSettingExcludeCondition } from '@/features/products/server-actions/product-query'
import {
  UpdateYahooAuctionCrawlSettingExcludeConditionInput,
  YahooAuctionCrawlSettingExcludeCondition,
} from '@/graphql/dist/client'

function EditForm({
  setMode,
  condition,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
  condition: YahooAuctionCrawlSettingExcludeCondition | undefined
}) {
  const params = useParams()
  const router = useRouter()

  const onSubmit: SubmitHandler<UpdateYahooAuctionCrawlSettingExcludeConditionInput> = async (
    data,
  ) => {
    const result = await updateYahooAuctionCrawlSettingExcludeCondition(data)
    if (result.data?.updateYahooAuctionCrawlSettingExcludeCondition.ok) {
      toast.success('success')
      setMode('list')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  const { register, handleSubmit } = useForm<UpdateYahooAuctionCrawlSettingExcludeConditionInput>({
    defaultValues: {
      productId: String(params.id),
      id: condition?.id,
      keyword: condition?.keyword,
      yahoo_auction_id: condition?.yahooAuctionId,
      seller_id: condition?.sellerId,
    },
  })

  return (
    <>
      <form onSubmit={handleSubmit(onSubmit)} className='w-full space-y-2'>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>キーワード</span>
          </div>
          <input
            {...register('keyword', { setValueAs: (v) => (v === '' ? null : v) })}
            className='input input-bordered'
          />
        </label>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>ヤフオクID</span>
          </div>
          <input
            {...register('yahoo_auction_id', { setValueAs: (v) => (v === '' ? null : v) })}
            className='input input-bordered'
          />
        </label>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>出品者ID</span>
          </div>
          <input
            {...register('seller_id', { setValueAs: (v) => (v === '' ? null : v) })}
            className='input input-bordered'
          />
        </label>
        <div className='pt-4'>
          <Button type='submit' color='primary' size='md' className='w-full'>
            更新
          </Button>
        </div>
      </form>
    </>
  )
}

export default EditForm
