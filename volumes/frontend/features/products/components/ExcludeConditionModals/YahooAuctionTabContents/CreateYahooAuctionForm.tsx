import { Dispatch, SetStateAction } from 'react'

import { useRouter, useParams } from 'next/navigation'
import { Button } from 'react-daisyui'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { createYahooAuctionCrawlSettingExcludeCondition } from '@/features/products/server-actions/product-query'
import { CreateYahooAuctionCrawlSettingExcludeConditionInput } from '@/graphql/dist/client'

const CreateYahooAuctionForm = ({
  setMode,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
}) => {
  const router = useRouter()
  const params = useParams()

  const { register, handleSubmit } = useForm<CreateYahooAuctionCrawlSettingExcludeConditionInput>({
    defaultValues: {
      productId: String(params.id),
      keyword: undefined,
      yahoo_auction_id: undefined,
      seller_id: undefined,
    },
  })

  const onSubmit: SubmitHandler<CreateYahooAuctionCrawlSettingExcludeConditionInput> = async (
    data,
  ) => {
    const result = await createYahooAuctionCrawlSettingExcludeCondition(data)
    if (result.data?.createYahooAuctionCrawlSettingExcludeCondition.ok) {
      toast.success('success')
      setMode('list')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

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
