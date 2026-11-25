'use client'

import { useRef } from 'react'

import { useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import {
  ScrollableModalBody,
  ScrollableModalBox,
  ScrollableModalFooter,
  ScrollableModalForm,
} from '@/components/ui/ScrollableModalBox'
import { updateProduct } from '@/features/products/api/actions'
import type { ProductList, UpdateProductData } from '@/features/products/api/types'
import type { Category } from '@/lib/category'

import { useUpdateProductModalState } from '../hooks/useUpdateProductModalState'

import type { SubmitHandler } from 'react-hook-form'

const UpdateProductModal = ({
  productId,
  product,
  categories,
}: {
  productId: number
  product: ProductList['products'][number] | undefined
  categories: Category[]
}) => {
  const router = useRouter()
  const submittingRef = useRef(false)

  const [modal, setModal] = useUpdateProductModalState()

  const defaultValues = {
    name: product?.name ?? '',
    categoryId: product?.category?.id ?? null,
  }

  const {
    register,
    handleSubmit,
    formState: { isSubmitting },
  } = useForm<UpdateProductData>({
    defaultValues,
    values: defaultValues,
  })

  const onSubmit: SubmitHandler<UpdateProductData> = async (data) => {
    if (submittingRef.current) return
    submittingRef.current = true
    try {
      const res = await updateProduct(productId, data)

      if (res.status === 200) {
        toast.success('計測設定を更新しました')
        setModal(false)
      } else {
        toast.error('計測設定の更新に失敗しました')
      }
      router.refresh()
    } catch {
      toast.error('計測設定の更新に失敗しました')
    } finally {
      submittingRef.current = false
    }
  }

  if (!product) return null

  return (
    <>
      <input
        type='checkbox'
        className='modal-toggle'
        checked={modal && !!product}
        onChange={(e) => setModal(e.target.checked)}
      />
      <div className='modal' role='dialog'>
        <ScrollableModalBox title='計測設定を更新' onClose={() => setModal(false)}>
          <ScrollableModalForm onSubmit={handleSubmit(onSubmit)}>
            <ScrollableModalBody>
              <div className='divider pt-6'>管理情報</div>
              <fieldset className='fieldset w-full'>
                <legend className='fieldset-legend'>管理コード</legend>
                <input {...register('name')} className='input w-full' />
              </fieldset>
              <fieldset className='fieldset w-full'>
                <legend className='fieldset-legend'>カテゴリ</legend>
                <select
                  {...register('categoryId', {
                    setValueAs: (value) => (value === '' ? null : Number(value)),
                  })}
                  className='select w-full'
                >
                  <option value=''>未設定</option>
                  {categories?.map((category) => (
                    <option key={category.id} value={category.id}>
                      {category.name}
                    </option>
                  ))}
                </select>
              </fieldset>
            </ScrollableModalBody>
            <ScrollableModalFooter>
              <button type='submit' disabled={isSubmitting} className='btn btn-primary w-full'>
                {isSubmitting ? '保存中…' : '保存'}
              </button>
            </ScrollableModalFooter>
          </ScrollableModalForm>
        </ScrollableModalBox>
        <button
          type='button'
          onClick={() => setModal(false)}
          className='modal-backdrop'
          aria-label='背景から閉じる'
        />
      </div>
    </>
  )
}

export default UpdateProductModal
