'use client'

import type { Dispatch, SetStateAction } from 'react'

import { useParams, usePathname, useRouter } from 'next/dist/client/components/navigation'
import { Button } from 'react-daisyui'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type {
  UpdatePcKoubouCrawlSettingRequiredKeywordInput,
  PcKoubouCrawlSettingRequiredKeyword,
} from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

import { updatePcKoubouCrawlSettingRequiredKeyword } from '@/features/products/server-actions/pcKoubouCrawlSettingRequiredKeywordQuery'

function EditForm({
  setMode,
  condition,
}: {
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
  condition: PcKoubouCrawlSettingRequiredKeyword | undefined
}) {
  const params = useParams()
  const router = useRouter()
  const pathname = usePathname()

  const onSubmit: SubmitHandler<UpdatePcKoubouCrawlSettingRequiredKeywordInput> = async (data) => {
    const result = await updatePcKoubouCrawlSettingRequiredKeyword(data, pathname)
    if (result.data?.updatePcKoubouCrawlSettingRequiredKeyword.ok) {
      toast.success('success')
      setMode('list')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  const { register, handleSubmit } = useForm<UpdatePcKoubouCrawlSettingRequiredKeywordInput>({
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
