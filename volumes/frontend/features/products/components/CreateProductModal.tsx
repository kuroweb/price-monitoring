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
import { createProduct } from '@/features/products/api/actions'
import type { CreateProductData, ProductList } from '@/features/products/api/types'
import YahooAuctionForm from '@/features/products/components/YahooAuctionForm'
import type { Category } from '@/lib/category'

import { useCreateProductModalState } from '../hooks/useCreateProductModalState'

import type { SubmitHandler } from 'react-hook-form'

const CreateProductModal = ({
  product,
  categories,
}: {
  product: ProductList['products'][number] | undefined
  categories: Category[]
}) => {
  const router = useRouter()
  const submittingRef = useRef(false)

  const [modal, setModal] = useCreateProductModalState()

  const defaultValues = {
    name: product?.name || '',
    categoryId: product?.category?.id || categories[0]?.id || null,
    yahooAuctionCrawlSetting: {
      keyword: product?.yahooAuctionCrawlSetting?.keyword || '',
      categoryId: product?.yahooAuctionCrawlSetting?.categoryId || null,
      minPrice: product?.yahooAuctionCrawlSetting?.minPrice ?? 0,
      maxPrice: product?.yahooAuctionCrawlSetting?.maxPrice ?? 0,
      enabled: product?.yahooAuctionCrawlSetting?.enabled ?? true,
      yahooAuctionCrawlSettingExcludeKeywords:
        product?.yahooAuctionCrawlSetting?.yahooAuctionCrawlSettingExcludeKeywords ?? [],
      yahooAuctionCrawlSettingRequiredKeywords:
        product?.yahooAuctionCrawlSetting?.yahooAuctionCrawlSettingRequiredKeywords ?? [],
    },
  }

  const {
    register,
    handleSubmit,
    getValues,
    setValue,
    formState: { isSubmitting },
  } = useForm<CreateProductData>({
    defaultValues,
    values: defaultValues,
  })

  const onSubmit: SubmitHandler<CreateProductData> = async (data) => {
    if (submittingRef.current) return
    submittingRef.current = true
    try {
      const res = await createProduct(data)

      if (res.status === 200) {
        toast.success('計測対象を追加しました')
        setModal(false)
      } else {
        toast.error('計測対象の追加に失敗しました')
      }
      router.refresh()
    } catch {
      toast.error('計測対象の追加に失敗しました')
    } finally {
      submittingRef.current = false
    }
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
        <ScrollableModalBox title='計測対象を追加' onClose={() => setModal(false)}>
          <ScrollableModalForm onSubmit={handleSubmit(onSubmit)}>
            <ScrollableModalBody>
              <div className='divider py-2'>管理情報</div>
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
              <div className='divider py-6'>計測条件</div>
              <div>
                <div className='py-4'>
                  <YahooAuctionForm
                    register={register}
                    getValues={getValues}
                    setValue={setValue}
                  />
                </div>
              </div>
            </ScrollableModalBody>
            <ScrollableModalFooter>
              <button type='submit' disabled={isSubmitting} className='btn btn-primary w-full'>
                {isSubmitting ? '登録中…' : '登録'}
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

export default CreateProductModal
