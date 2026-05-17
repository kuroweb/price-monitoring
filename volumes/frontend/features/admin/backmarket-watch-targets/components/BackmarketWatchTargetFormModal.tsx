'use client'

import { useEffect } from 'react'

import { useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type {
  BackmarketWatchTarget,
  CreateBackmarketWatchTargetData,
  UpdateBackmarketWatchTargetData,
} from '@/lib/api'

import { createBackmarketWatchTarget, updateBackmarketWatchTarget } from '@/lib/actions'

type Props = {
  isOpen: boolean
  onClose: () => void
  target?: BackmarketWatchTarget
  mode: 'create' | 'edit'
}

const BackmarketWatchTargetFormModal = ({ isOpen, onClose, target, mode }: Props) => {
  const router = useRouter()
  const { register, handleSubmit, reset } = useForm<CreateBackmarketWatchTargetData>({
    defaultValues: {
      name: '',
      url: '',
      enabled: true,
    },
  })

  useEffect(() => {
    reset({
      name: target?.name || '',
      url: target?.url || '',
      enabled: target?.enabled ?? true,
    })
  }, [reset, target])

  const onSubmit = async (
    data: CreateBackmarketWatchTargetData | UpdateBackmarketWatchTargetData,
  ) => {
    const res = mode === 'create' || !target?.id
      ? await createBackmarketWatchTarget(data)
      : await updateBackmarketWatchTarget(target.id, data)

    if (res.status === 200) {
      toast.success('success')
      onClose()
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  return (
    <>
      <input type='checkbox' className='modal-toggle' checked={isOpen} onChange={() => onClose()} />
      <div className='modal' role='dialog'>
        <div className='modal-box h-fit'>
          <button onClick={onClose} className='btn btn-circle btn-ghost btn-sm absolute right-4 top-4'>
            ✕
          </button>
          <h3 className='text-lg font-bold'>{mode === 'create' ? '監視対象を追加' : '監視対象を更新'}</h3>
          <form onSubmit={handleSubmit(onSubmit)} className='space-y-3 pt-4'>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>名前</span>
              </div>
              <input {...register('name', { required: true })} className='input input-bordered' />
            </label>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>URL</span>
              </div>
              <input {...register('url', { required: true })} className='input input-bordered' />
            </label>
            <label className='label cursor-pointer justify-start gap-3'>
              <input type='checkbox' {...register('enabled')} className='checkbox checkbox-sm' />
              <span className='label-text'>有効</span>
            </label>
            <button type='submit' className='btn btn-primary w-full'>
              {mode === 'create' ? '登録' : '更新'}
            </button>
          </form>
        </div>
        <div onClick={onClose} className='modal-backdrop' />
      </div>
    </>
  )
}

export default BackmarketWatchTargetFormModal
