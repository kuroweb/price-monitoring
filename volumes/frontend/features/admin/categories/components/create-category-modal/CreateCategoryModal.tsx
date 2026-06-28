'use client'

import { useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useCreateCategoryModalState } from './hooks/useCreateCategoryModalState'

import type { Category, CreateCategoryData } from '@/lib/api'
import type { SubmitHandler } from 'react-hook-form'

import {
  ScrollableModalBody,
  ScrollableModalBox,
  ScrollableModalFooter,
  ScrollableModalForm,
} from '@/components/ui/ScrollableModalBox'
import { createCategory } from '@/lib/actions'

const CreateCategoryModal = ({ categories }: { categories: Category[] }) => {
  const router = useRouter()
  const [modal, setModal] = useCreateCategoryModalState()

  const { register, handleSubmit, reset } = useForm<CreateCategoryData>({
    defaultValues: {
      name: '',
      parentId: null,
    },
  })

  const onSubmit: SubmitHandler<CreateCategoryData> = async (data) => {
    const result = await createCategory(data)

    if (result.status === 200) {
      toast.success('カテゴリを追加しました')
      reset({ name: '', parentId: null })
      setModal(false)
    } else {
      toast.error('追加に失敗しました')
    }
    router.refresh()
  }

  return (
    <>
      <input
        type='checkbox'
        className='modal-toggle'
        checked={modal}
        onChange={(e) => setModal(e.target.checked)}
      />
      <div className='modal' role='dialog'>
        <ScrollableModalBox title='カテゴリを追加' onClose={() => setModal(false)}>
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
                {categories.map((category) => (
                  <option key={category.id} value={category.id}>
                    {category.name}
                  </option>
                ))}
              </select>
            </fieldset>
            <fieldset className='fieldset w-full'>
              <legend className='fieldset-legend'>カテゴリ名</legend>
              <input {...register('name', { required: true })} className='input w-full' />
            </fieldset>
            </ScrollableModalBody>
            <ScrollableModalFooter>
            <button type='submit' className='btn btn-primary mt-4 w-full max-sm:mt-0'>
              登録
            </button>
            </ScrollableModalFooter>
          </ScrollableModalForm>
        </ScrollableModalBox>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default CreateCategoryModal
