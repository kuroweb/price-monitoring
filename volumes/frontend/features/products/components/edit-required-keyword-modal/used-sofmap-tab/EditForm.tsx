'use client'

import type { Dispatch, SetStateAction } from 'react'

import { useParams,  useRouter } from 'next/dist/client/components/navigation'
import { Button } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type {
  UpdateUsedSofmapCrawlSettingRequiredKeywordInput,
  UsedSofmapCrawlSettingRequiredKeyword,
} from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

import { updateUsedSofmapCrawlSettingRequiredKeyword } from '@/features/products/server-actions/graphql/usedSofmapCrawlSettingRequiredKeywordQuery'

function EditForm({
  setMode,
  condition,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
  condition: UsedSofmapCrawlSettingRequiredKeyword | undefined
}) {
  const params = useParams()
  const router = useRouter()
  

  const onSubmit: SubmitHandler<UpdateUsedSofmapCrawlSettingRequiredKeywordInput> = async (
    data,
  ) => {
    const result = await updateUsedSofmapCrawlSettingRequiredKeyword(data)
    if (result.data?.updateUsedSofmapCrawlSettingRequiredKeyword.ok) {
      toast.success('success')
      setMode('list')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  const { register, handleSubmit } = useForm<UpdateUsedSofmapCrawlSettingRequiredKeywordInput>({
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
