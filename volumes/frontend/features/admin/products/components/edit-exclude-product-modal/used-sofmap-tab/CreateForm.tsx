'use client'

import type { Dispatch, SetStateAction } from 'react'

import { useRouter, useParams } from 'next/navigation'
import { Button } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type { CreateUsedSofmapCrawlSettingExcludeProductInput } from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

import { createUsedSofmapCrawlSettingExcludeProduct } from '@/server-actions/usedSofmapCrawlSettingExcludeProductQuery'

const CreateForm = ({
  setMode,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
}) => {
  const router = useRouter()
  const params = useParams()

  const { register, handleSubmit } = useForm<CreateUsedSofmapCrawlSettingExcludeProductInput>({
    defaultValues: {
      productId: String(params.id),
      externalId: '',
    },
  })

  const onSubmit: SubmitHandler<CreateUsedSofmapCrawlSettingExcludeProductInput> = async (data) => {
    const result = await createUsedSofmapCrawlSettingExcludeProduct(data)
    if (
      result?.data?.createUsedSofmapCrawlSettingExcludeProduct.__typename ===
        'CreateUsedSofmapCrawlSettingExcludeProductResultError' &&
      result?.data?.createUsedSofmapCrawlSettingExcludeProduct.error.code !== '409'
    ) {
      return toast.error('登録に失敗しました。')
    }

    setMode('list')
    toast.success('success')
    router.refresh()
  }

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
            追加
          </Button>
        </div>
      </form>
    </>
  )
}

export default CreateForm
