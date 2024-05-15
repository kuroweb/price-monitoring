'use client'

import { useParams, useRouter } from 'next/navigation'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useBulkDeleteRequiredKeywordModalState } from '../hooks/useBulkDeleteRequiredKeywordModalState'
import {
  deleteIosysCrawlSettingRequiredKeyword,
  deleteJanparaCrawlSettingRequiredKeyword,
  deleteMercariCrawlSettingRequiredKeyword,
  deletePcKoubouCrawlSettingRequiredKeyword,
  deleteYahooAuctionCrawlSettingRequiredKeyword,
} from '../server-actions/productQuery'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

type inputType = {
  keyword: string | null
}

const BulkDeleteRequiredKeywordModal = ({
  yahooAuctionCrawlSettingRequiredKeywords,
  mercariCrawlSettingRequiredKeywords,
  janparaCrawlSettingRequiredKeywords,
  iosysCrawlSettingRequiredKeywords,
  pcKoubouCrawlSettingRequiredKeywords,
}: {
  yahooAuctionCrawlSettingRequiredKeywords: GetProductDetailPageDataQuery['product']['yahooAuctionCrawlSetting']['yahooAuctionCrawlSettingRequiredKeywords']
  mercariCrawlSettingRequiredKeywords: GetProductDetailPageDataQuery['product']['mercariCrawlSetting']['mercariCrawlSettingRequiredKeywords']
  janparaCrawlSettingRequiredKeywords: GetProductDetailPageDataQuery['product']['janparaCrawlSetting']['janparaCrawlSettingRequiredKeywords']
  iosysCrawlSettingRequiredKeywords: GetProductDetailPageDataQuery['product']['iosysCrawlSetting']['iosysCrawlSettingRequiredKeywords']
  pcKoubouCrawlSettingRequiredKeywords: GetProductDetailPageDataQuery['product']['pcKoubouCrawlSetting']['pcKoubouCrawlSettingRequiredKeywords']
}) => {
  const router = useRouter()
  const params = useParams()

  const [modal, setModal] = useBulkDeleteRequiredKeywordModalState()
  const { register, handleSubmit, setValue } = useForm<inputType>({
    defaultValues: {
      keyword: null,
    },
  })

  const onSubmit: SubmitHandler<inputType> = async (input) => {
    bulkDelete(input)
  }

  const bulkDelete = async (input: inputType) => {
    const productId = String(params.id)

    for (const requiredKeyword of yahooAuctionCrawlSettingRequiredKeywords) {
      if (requiredKeyword.keyword === input.keyword) {
        try {
          const result = await deleteYahooAuctionCrawlSettingRequiredKeyword(
            requiredKeyword.id,
            productId,
          )
          if (
            result?.data?.deleteYahooAuctionCrawlSettingRequiredKeyword.__typename ===
              'DeleteYahooAuctionCrawlSettingRequiredKeywordResultError' &&
            result?.data?.deleteYahooAuctionCrawlSettingRequiredKeyword.error.code !== '404'
          ) {
            toast.error('一括削除に失敗しました。')
            return
          }
        } catch (error) {
          toast.error('一括削除に失敗しました。')
          return
        }
      }
    }

    for (const requiredKeyword of mercariCrawlSettingRequiredKeywords) {
      if (requiredKeyword.keyword === input.keyword) {
        try {
          const result = await deleteMercariCrawlSettingRequiredKeyword(
            requiredKeyword.id,
            productId,
          )
          if (
            result?.data?.deleteMercariCrawlSettingRequiredKeyword.__typename ===
              'DeleteMercariCrawlSettingRequiredKeywordResultError' &&
            result?.data?.deleteMercariCrawlSettingRequiredKeyword.error.code !== '404'
          ) {
            toast.error('一括削除に失敗しました。')
            return
          }
        } catch (error) {
          toast.error('一括削除に失敗しました。')
          return
        }
      }
    }

    for (const requiredKeyword of janparaCrawlSettingRequiredKeywords) {
      if (requiredKeyword.keyword === input.keyword) {
        try {
          const result = await deleteJanparaCrawlSettingRequiredKeyword(
            requiredKeyword.id,
            productId,
          )
          if (
            result?.data?.deleteJanparaCrawlSettingRequiredKeyword.__typename ===
              'DeleteJanparaCrawlSettingRequiredKeywordResultError' &&
            result?.data?.deleteJanparaCrawlSettingRequiredKeyword.error.code !== '404'
          ) {
            toast.error('一括削除に失敗しました。')
            return
          }
        } catch (error) {
          toast.error('一括削除に失敗しました。')
          return
        }
      }
    }

    for (const requiredKeyword of iosysCrawlSettingRequiredKeywords) {
      if (requiredKeyword.keyword === input.keyword) {
        try {
          const result = await deleteIosysCrawlSettingRequiredKeyword(requiredKeyword.id, productId)
          if (
            result?.data?.deleteIosysCrawlSettingRequiredKeyword.__typename ===
              'DeleteIosysCrawlSettingRequiredKeywordResultError' &&
            result?.data?.deleteIosysCrawlSettingRequiredKeyword.error.code !== '404'
          ) {
            toast.error('一括削除に失敗しました。')
            return
          }
        } catch (error) {
          toast.error('一括削除に失敗しました。')
          return
        }
      }
    }

    for (const requiredKeyword of pcKoubouCrawlSettingRequiredKeywords) {
      if (requiredKeyword.keyword === input.keyword) {
        try {
          const result = await deletePcKoubouCrawlSettingRequiredKeyword(
            requiredKeyword.id,
            productId,
          )
          if (
            result?.data?.deletePcKoubouCrawlSettingRequiredKeyword.__typename ===
              'DeletePcKoubouCrawlSettingRequiredKeywordResultError' &&
            result?.data?.deletePcKoubouCrawlSettingRequiredKeyword.error.code !== '404'
          ) {
            toast.error('一括削除に失敗しました。')
            return
          }
        } catch (error) {
          toast.error('一括削除に失敗しました。')
          return
        }
      }
    }

    setModal(false)
    setValue('keyword', null)
    toast.success('一括削除に成功しました。')
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
        <div className='modal-box h-fit'>
          <div
            onClick={() => setModal(false)}
            className='btn btn-sm btn-circle btn-ghost absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='font-bold text-lg'>除外キーワード（一括削除）</h3>
          <form onSubmit={handleSubmit(onSubmit)} className='w-full space-y-2 pt-4'>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>キーワード</span>
              </div>
              <input {...register('keyword')} className='input input-bordered' />
            </label>
            <div className='pt-4'>
              <button type='submit' className='btn btn-md btn-primary w-full'>
                すべてのプラットフォームから削除
              </button>
            </div>
          </form>
        </div>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default BulkDeleteRequiredKeywordModal
