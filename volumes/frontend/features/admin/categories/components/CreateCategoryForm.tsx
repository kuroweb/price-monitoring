'use client'

import { useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import type { Category, CreateCategoryData } from '@/lib/api'
import type { SubmitHandler } from 'react-hook-form'

import { createCategory } from '@/lib/actions'

const CreateCategoryForm = ({ categories }: { categories: Category[] }) => {
  const router = useRouter()
  const { register, handleSubmit } = useForm<CreateCategoryData>()

  const onSubmit: SubmitHandler<CreateCategoryData> = async (data) => {
    const result = await createCategory(data)

    if (result.status === 200) {
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
