'use client'

import { Dispatch, SetStateAction } from 'react'

import { useRouter, useParams } from 'next/navigation'
import { Button } from 'react-daisyui'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { createMercariCrawlSettingExcludeProduct } from '@/features/products/server-actions/productQuery'
import { CreateMercariCrawlSettingExcludeProductInput } from '@/graphql/dist/client'

const CreateForm = ({
  setMode,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
}) => {
  const router = useRouter()
  const params = useParams()

  const { register, handleSubmit } = useForm<CreateMercariCrawlSettingExcludeProductInput>({
    defaultValues: {
      productId: String(params.id),
      externalId: '',
    },
  })

  const onSubmit: SubmitHandler<CreateMercariCrawlSettingExcludeProductInput> = async (data) => {
    const result = await createMercariCrawlSettingExcludeProduct(data)
    if (result.data?.createMercariCrawlSettingExcludeProduct.ok) {
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
