'use client'

import type { Dispatch, SetStateAction } from 'react'

import { useParams, usePathname, useRouter } from 'next/dist/client/components/navigation'
import { Button } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type {
  UpdateMercariCrawlSettingExcludeProductInput,
  MercariCrawlSettingExcludeProduct,
} from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

import { updateMercariCrawlSettingExcludeProduct } from '@/features/products/server-actions/mercariCrawlSettingExcludeProductQuery'

function EditForm({
  setMode,
  condition,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
  condition: MercariCrawlSettingExcludeProduct | undefined
}) {
  const params = useParams()
  const router = useRouter()
  const pathname = usePathname()

  const onSubmit: SubmitHandler<UpdateMercariCrawlSettingExcludeProductInput> = async (data) => {
    const result = await updateMercariCrawlSettingExcludeProduct(data, pathname)
    if (
      result?.data?.updateMercariCrawlSettingExcludeProduct.__typename ===
        'UpdateMercariCrawlSettingExcludeProductResultError' &&
      result?.data?.updateMercariCrawlSettingExcludeProduct.error.code !== '409'
    ) {
      return toast.error('登録に失敗しました。')
    }

    setMode('list')
    toast.success('success')
    router.refresh()
  }

  const { register, handleSubmit } = useForm<UpdateMercariCrawlSettingExcludeProductInput>({
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
