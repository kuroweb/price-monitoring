'use client'

import { Dispatch, SetStateAction } from 'react'

import { useParams, useRouter } from 'next/dist/client/components/navigation'
import { Button } from 'react-daisyui'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { updateYahooAuctionCrawlSettingExcludeProduct } from '@/features/products/server-actions/productQuery'
import {
  UpdateYahooAuctionCrawlSettingExcludeProductInput,
  YahooAuctionCrawlSettingExcludeProduct,
} from '@/graphql/dist/client'

function EditForm({
  setMode,
  condition,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
  condition: YahooAuctionCrawlSettingExcludeProduct | undefined
}) {
  const params = useParams()
  const router = useRouter()

  const onSubmit: SubmitHandler<UpdateYahooAuctionCrawlSettingExcludeProductInput> = async (
    data,
  ) => {
    const result = await updateYahooAuctionCrawlSettingExcludeProduct(data)
    if (result.data?.updateYahooAuctionCrawlSettingExcludeProduct.ok) {
      toast.success('success')
      setMode('list')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  const { register, handleSubmit } = useForm<UpdateYahooAuctionCrawlSettingExcludeProductInput>({
    defaultValues: {
      productId: String(params.id),
      id: condition?.id,
      externalId: condition?.externalId,
    },
  })

  return (
    <>
      <form onSubmit={handleSubmit(onSubmit)} className='w-full space-y-2'>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>キーワード</span>
          </div>
          <input {...register('externalId')} className='input input-bordered' />
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