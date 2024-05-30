'use client'

import type { Dispatch, SetStateAction } from 'react'

import { useParams, usePathname, useRouter } from 'next/dist/client/components/navigation'
import { Button } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type {
  UpdateYahooAuctionCrawlSettingExcludeProductInput,
  YahooAuctionCrawlSettingExcludeProduct,
} from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

import { updateYahooAuctionCrawlSettingExcludeProduct } from '@/features/products/server-actions/productQuery'

function EditForm({
  setMode,
  condition,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
  condition: YahooAuctionCrawlSettingExcludeProduct | undefined
}) {
  const params = useParams()
  const router = useRouter()
  const pathname = usePathname()

  const onSubmit: SubmitHandler<UpdateYahooAuctionCrawlSettingExcludeProductInput> = async (
    data,
  ) => {
    const result = await updateYahooAuctionCrawlSettingExcludeProduct(data, pathname)
    if (
      result?.data?.updateYahooAuctionCrawlSettingExcludeProduct.__typename ===
        'UpdateYahooAuctionCrawlSettingExcludeProductResultError' &&
      result?.data?.updateYahooAuctionCrawlSettingExcludeProduct.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    setMode('list')
    toast.success('success')
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
            <span className='label-text'>商品ID</span>
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
