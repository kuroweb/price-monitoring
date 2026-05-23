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
            {categories.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
        </fieldset>
        <fieldset className='fieldset w-full'>
        <legend className='fieldset-legend'>カテゴリ名</legend>
          <input {...register('name')} className='input w-full' />
      </fieldset>
        <button type='submit' className='btn btn-primary mt-4 w-full'>
          登録
        </button>
      </form>
    </>
  )
}

export default CreateCategoryForm
