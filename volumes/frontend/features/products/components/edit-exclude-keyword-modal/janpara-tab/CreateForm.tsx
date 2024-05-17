'use client'

import { Dispatch, SetStateAction } from 'react'

import { useRouter, useParams } from 'next/navigation'
import { Button } from 'react-daisyui'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { createJanparaCrawlSettingExcludeKeyword } from '@/features/products/server-actions/productQuery'
import { CreateJanparaCrawlSettingExcludeKeywordInput } from '@/graphql/dist/client'

const CreateForm = ({
  setMode,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
}) => {
  const router = useRouter()
  const params = useParams()

  const { register, handleSubmit } = useForm<CreateJanparaCrawlSettingExcludeKeywordInput>({
    defaultValues: {
      productId: String(params.id),
      keyword: null,
    },
  })

  const onSubmit: SubmitHandler<CreateJanparaCrawlSettingExcludeKeywordInput> = async (data) => {
    const result = await createJanparaCrawlSettingExcludeKeyword(data)
    if (result.data?.createJanparaCrawlSettingExcludeKeyword.ok) {
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
