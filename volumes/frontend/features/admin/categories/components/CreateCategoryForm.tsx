'use client'

import { useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { createCategory } from '../../../../server-actions/categoryQuery'

import type { CreateCategoryInput, AdminCategoriesPageDataQuery } from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

const CreateCategoryForm = ({
  categories,
}: {
  categories: AdminCategoriesPageDataQuery['categories']
}) => {
  const router = useRouter()
  const { register, handleSubmit } = useForm<{ parentId: string; name: string }>()

  const onSubmit: SubmitHandler<CreateCategoryInput> = async (input) => {
    const result = await createCategory(input)

    if (result.data?.createCategory.ok) {
      toast.success('success')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  return (
    <>
      <form onSubmit={handleSubmit(onSubmit)} className='w-full md:w-1/2'>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>親カテゴリ</span>
          </div>
          <select {...register('parentId')} className='input input-bordered'>
            <option value=''>なし</option>
            {categories.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
        </label>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>カテゴリ名</span>
          </div>
          <input {...register('name')} className='input input-bordered' />
        </label>
        <button type='submit' className='btn btn-primary mt-4 w-full'>
          登録
        </button>
      </form>
    </>
  )
}

export default CreateCategoryForm
