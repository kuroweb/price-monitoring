'use client'

import type { Dispatch, SetStateAction } from 'react'

import { useParams, useRouter } from 'next/dist/client/components/navigation'
import { Button } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type {
  UpdateIosysCrawlSettingExcludeProductInput,
  IosysCrawlSettingExcludeProduct,
} from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

import { updateIosysCrawlSettingExcludeProduct } from '@/features/products/server-actions/graphql/iosysCrawlSettingExcludeProductQuery'

function EditForm({
  setMode,
  condition,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
  condition: IosysCrawlSettingExcludeProduct | undefined
}) {
  const params = useParams()
  const router = useRouter()

  const onSubmit: SubmitHandler<UpdateIosysCrawlSettingExcludeProductInput> = async (data) => {
    const result = await updateIosysCrawlSettingExcludeProduct(data)
    if (
      result?.data?.updateIosysCrawlSettingExcludeProduct.__typename ===
        'UpdateIosysCrawlSettingExcludeProductResultError' &&
      result?.data?.updateIosysCrawlSettingExcludeProduct.error.code !== '409'
    ) {
      return toast.error('登録に失敗しました。')
    }

    setMode('list')
    toast.success('success')
    router.refresh()
  }

  const { register, handleSubmit } = useForm<UpdateIosysCrawlSettingExcludeProductInput>({
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
