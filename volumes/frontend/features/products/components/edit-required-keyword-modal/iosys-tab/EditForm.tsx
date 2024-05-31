'use client'

import type { Dispatch, SetStateAction } from 'react'

import { useParams, usePathname, useRouter } from 'next/dist/client/components/navigation'
import { Button } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type {
  UpdateIosysCrawlSettingRequiredKeywordInput,
  IosysCrawlSettingRequiredKeyword,
} from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

import { updateIosysCrawlSettingRequiredKeyword } from '@/features/products/server-actions/iosysCrawlSettingRequiredKeywordQuery'

function EditForm({
  setMode,
  condition,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
  condition: IosysCrawlSettingRequiredKeyword | undefined
}) {
  const params = useParams()
  const router = useRouter()
  const pathname = usePathname()

  const onSubmit: SubmitHandler<UpdateIosysCrawlSettingRequiredKeywordInput> = async (data) => {
    const result = await updateIosysCrawlSettingRequiredKeyword(data, pathname)
    if (result.data?.updateIosysCrawlSettingRequiredKeyword.ok) {
      toast.success('success')
      setMode('list')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  const { register, handleSubmit } = useForm<UpdateIosysCrawlSettingRequiredKeywordInput>({
    defaultValues: {
      productId: String(params.id),
      id: condition?.id,
      keyword: condition?.keyword,
    },
  })

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
            更新
          </Button>
        </div>
      </form>
    </>
  )
}

export default EditForm
