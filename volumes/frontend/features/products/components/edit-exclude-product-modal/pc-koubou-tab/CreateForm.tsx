'use client'

import type { Dispatch, SetStateAction } from 'react'

import { useRouter, useParams, usePathname } from 'next/navigation'
import { Button } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type { CreatePcKoubouCrawlSettingExcludeProductInput } from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

import { createPcKoubouCrawlSettingExcludeProduct } from '@/features/products/server-actions/pcKoubouCrawlSettingExcludeProductQuery'

const CreateForm = ({
  setMode,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
}) => {
  const router = useRouter()
  const params = useParams()
  const pathname = usePathname()

  const { register, handleSubmit } = useForm<CreatePcKoubouCrawlSettingExcludeProductInput>({
    defaultValues: {
      productId: String(params.id),
      externalId: '',
    },
  })

  const onSubmit: SubmitHandler<CreatePcKoubouCrawlSettingExcludeProductInput> = async (data) => {
    const result = await createPcKoubouCrawlSettingExcludeProduct(data, pathname)
    if (
      result?.data?.createPcKoubouCrawlSettingExcludeProduct.__typename ===
        'CreatePcKoubouCrawlSettingExcludeProductResultError' &&
      result?.data?.createPcKoubouCrawlSettingExcludeProduct.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
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
