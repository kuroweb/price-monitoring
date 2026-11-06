'use client'

import { useEffect } from 'react'

import { useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import {
  ScrollableModalBody,
  ScrollableModalBox,
  ScrollableModalFooter,
  ScrollableModalForm,
} from '@/components/ui/ScrollableModalBox'
import { createBackmarketWatchTarget, updateBackmarketWatchTarget } from '@/lib/actions'
import type {
  BackmarketWatchTarget,
  CreateBackmarketWatchTargetData,
  UpdateBackmarketWatchTargetData,
} from '@/lib/api'

type Props = {
  isOpen: boolean
  onClose: () => void
  target?: BackmarketWatchTarget
  mode: 'create' | 'edit'
}

const BackmarketWatchTargetFormModal = ({ isOpen, onClose, target, mode }: Props) => {
  const router = useRouter()
  const {
    register,
    handleSubmit,
    reset,
    formState: { isSubmitting },
  } = useForm<CreateBackmarketWatchTargetData>({
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
    try {
      const res =
        mode === 'create' || !target?.id
          ? await createBackmarketWatchTarget(data)
          : await updateBackmarketWatchTarget(target.id, data)

      if (res.status === 200) {
        toast.success(mode === 'create' ? '計測対象を追加しました' : '計測対象を更新しました')
        onClose()
      } else {
        toast.error(
          mode === 'create' ? '計測対象の追加に失敗しました' : '計測対象の更新に失敗しました',
        )
      }
      router.refresh()
    } catch {
      toast.error('計測対象の保存に失敗しました')
    }
  }

  return (
    <>
      <input type='checkbox' className='modal-toggle' checked={isOpen} onChange={() => onClose()} />
      <div className='modal' role='dialog'>
        <ScrollableModalBox
          title={mode === 'create' ? '計測対象を追加' : '計測対象を更新'}
          onClose={onClose}
        >
          <ScrollableModalForm onSubmit={handleSubmit(onSubmit)}>
            <ScrollableModalBody>
              <div className='space-y-3 pt-4 max-sm:pt-0'>
                <fieldset disabled={isSubmitting} className='fieldset w-full'>
                  <legend className='fieldset-legend'>名前</legend>
                  <input {...register('name', { required: true })} className='input w-full' />
                </fieldset>
                <fieldset disabled={isSubmitting} className='fieldset w-full'>
                  <legend className='fieldset-legend'>URL</legend>
                  <input {...register('url', { required: true })} className='input w-full' />
                </fieldset>
                <label className='label cursor-pointer justify-start gap-3'>
                  <input
                    type='checkbox'
                    disabled={isSubmitting}
                    {...register('enabled')}
                    className='checkbox checkbox-sm'
                  />
                  <span>有効</span>
                </label>
              </div>
            </ScrollableModalBody>
            <ScrollableModalFooter>
              <button disabled={isSubmitting} type='submit' className='btn btn-primary w-full'>
                {isSubmitting
                  ? mode === 'create'
                    ? '登録中…'
                    : '保存中…'
                  : mode === 'create'
                    ? '登録'
                    : '更新'}
              </button>
            </ScrollableModalFooter>
          </ScrollableModalForm>
        </ScrollableModalBox>
        <button
          type='button'
          onClick={onClose}
          className='modal-backdrop'
          aria-label='背景から閉じる'
        />
      </div>
    </>
  )
}

export default BackmarketWatchTargetFormModal
