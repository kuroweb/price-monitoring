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

import {
  ScrollableModalBody,
  ScrollableModalBox,
  ScrollableModalFooter,
  ScrollableModalForm,
} from '@/components/ui/ScrollableModalBox'
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
        <ScrollableModalBox
          title={mode === 'create' ? '監視対象を追加' : '監視対象を更新'}
          onClose={onClose}
        >
          <ScrollableModalForm onSubmit={handleSubmit(onSubmit)}>
            <ScrollableModalBody>
            <div className='space-y-3 pt-4 max-sm:pt-0'>
            <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>名前</legend>
              <input {...register('name', { required: true })} className='input w-full' />
      </fieldset>
            <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>URL</legend>
              <input {...register('url', { required: true })} className='input w-full' />
      </fieldset>
            <label className='label cursor-pointer justify-start gap-3'>
              <input type='checkbox' {...register('enabled')} className='checkbox checkbox-sm' />
              <span>有効</span>
            </label>
            </div>
            </ScrollableModalBody>
            <ScrollableModalFooter>
            <button type='submit' className='btn btn-primary w-full'>
              {mode === 'create' ? '登録' : '更新'}
            </button>
            </ScrollableModalFooter>
          </ScrollableModalForm>
        </ScrollableModalBox>
        <div onClick={onClose} className='modal-backdrop' />
      </div>
    </>
  )
}

export default BackmarketWatchTargetFormModal
