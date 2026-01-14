'use client'

import { useEffect } from 'react'

import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useUpdateCategoryModalState } from './hooks/useUpdateCategoryModalState'

import type { Category } from '@/lib/api'

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
        <div className='modal-box h-fit'>
          <div
            onClick={() => setModal(false)}
            className='btn btn-circle btn-ghost btn-sm absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='text-lg font-bold'>カテゴリを編集</h3>
          <form onSubmit={handleSubmit(onSubmit)}>
            <div className='divider pt-6'>カテゴリ情報</div>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>親カテゴリ</span>
              </div>
              <select
                {...register('parentId', {
                  setValueAs: (v) => (v === '' ? null : Number(v)),
                })}
                className='input input-bordered'
              >
                <option value=''>なし</option>
                {availableParentCategories.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.name}
                  </option>
                ))}
              </select>
            </label>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>カテゴリ名</span>
              </div>
              <input
                {...register('name', { required: 'カテゴリ名は必須です' })}
                className='input input-bordered'
              />
              {errors.name && <span className='text-sm text-error'>{errors.name.message}</span>}
            </label>
            <button type='submit' className='btn btn-primary mt-4 w-full'>
              更新
            </button>
          </form>
        </div>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default UpdateCategoryModal
