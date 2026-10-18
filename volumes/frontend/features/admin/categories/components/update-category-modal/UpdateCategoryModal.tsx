'use client'

import { useEffect } from 'react'

import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useUpdateCategoryModalState } from './hooks/useUpdateCategoryModalState'

import type { Category } from '@/lib/api'

import {
  ScrollableModalBody,
  ScrollableModalBox,
  ScrollableModalFooter,
  ScrollableModalForm,
} from '@/components/ui/ScrollableModalBox'
import { updateCategory } from '@/lib/actions'

const UpdateCategoryModal = ({
  category,
  categories,
}: {
  category?: Category
  categories: Category[]
}) => {
  const [modal, setModal] = useUpdateCategoryModalState()

  const defaultValues = {
    name: category?.name ?? '',
    parentId: category?.parentId ?? null,
  }

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm({ defaultValues })

  useEffect(() => {
    if (category) {
      reset({
        name: category.name,
        parentId: category.parentId,
      })
    }
  }, [category, reset])

  const onSubmit = async (data: { name: string; parentId: number | null }) => {
    if (!category) return

    const result = await updateCategory(category.id, {
      name: data.name,
      parentId: data.parentId,
    })

    if (result.status === 200) {
      toast.success('カテゴリを更新しました')
      setModal(false)
    } else {
      toast.error('更新に失敗しました')
    }
  }

  const availableParentCategories = categories.filter((c) => {
    if (!category) return true
    if (c.id === category.id) return false
    return true
  })

  return (
    <>
      <input
        type='checkbox'
        className='modal-toggle'
        checked={modal}
        onChange={(e) => setModal(e.target.checked)}
      />
      <div className='modal' role='dialog'>
        <ScrollableModalBox title='カテゴリを編集' onClose={() => setModal(false)}>
          <ScrollableModalForm onSubmit={handleSubmit(onSubmit)}>
            <ScrollableModalBody>
            <div className='divider pt-6'>カテゴリ情報</div>
            <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>親カテゴリ</legend>
              <select
                {...register('parentId', {
                  setValueAs: (value) => {
                    const id = Number(value)
                    return Number.isInteger(id) && id > 0 ? id : null
                  },
                })}
                className='select w-full'
              >
                <option value=''>なし</option>
                {availableParentCategories.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.name}
                  </option>
                ))}
              </select>
        </fieldset>
            <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>カテゴリ名</legend>
              <input
                {...register('name', { required: 'カテゴリ名は必須です' })}
                className='input w-full'
              />
              {errors.name && <span className='text-sm text-error'>{errors.name.message}</span>}
            </fieldset>
            </ScrollableModalBody>
            <ScrollableModalFooter>
            <button type='submit' className='btn btn-primary mt-4 w-full max-sm:mt-0'>
              更新
            </button>
            </ScrollableModalFooter>
          </ScrollableModalForm>
        </ScrollableModalBox>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default UpdateCategoryModal
