'use client'

import { useParams, usePathname, useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useBulkEditRequiredKeywordModalState } from '../../hooks/useBulkEditRequiredKeywordModalState'
import { deleteIosysCrawlSettingRequiredKeyword } from '../../server-actions/iosysCrawlSettingRequiredKeywordQuery'
import { deleteJanparaCrawlSettingRequiredKeyword } from '../../server-actions/janparaCrawlSettingRequiredKeywordQuery'
import { deleteMercariCrawlSettingRequiredKeyword } from '../../server-actions/mercariCrawlSettingRequiredKeywordQuery'
import { deletePcKoubouCrawlSettingRequiredKeyword } from '../../server-actions/pcKoubouCrawlSettingRequiredKeywordQuery'
import { deleteYahooAuctionCrawlSettingRequiredKeyword } from '../../server-actions/yahooAuctionCrawlSettingRequiredKeywordQuery'

import type { GetProductDetailPageDataQuery } from '@/graphql/dist/client'
import type { SubmitHandler } from 'react-hook-form'

type inputType = {
  keyword: string | null
}

const DeleteForm = ({
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
  const pathname = usePathname()

  const [_, setModal] = useBulkEditRequiredKeywordModalState()
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

    for (const excludeKeyword of yahooAuctionCrawlSettingRequiredKeywords) {
      if (excludeKeyword.keyword === input.keyword) {
        try {
          const result = await deleteYahooAuctionCrawlSettingRequiredKeyword(
            excludeKeyword.id,
            productId,
            pathname,
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

    for (const excludeKeyword of mercariCrawlSettingRequiredKeywords) {
      if (excludeKeyword.keyword === input.keyword) {
        try {
          const result = await deleteMercariCrawlSettingRequiredKeyword(
            excludeKeyword.id,
            productId,
            pathname,
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

    for (const excludeKeyword of janparaCrawlSettingRequiredKeywords) {
      if (excludeKeyword.keyword === input.keyword) {
        try {
          const result = await deleteJanparaCrawlSettingRequiredKeyword(
            excludeKeyword.id,
            productId,
            pathname,
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

    for (const excludeKeyword of iosysCrawlSettingRequiredKeywords) {
      if (excludeKeyword.keyword === input.keyword) {
        try {
          const result = await deleteIosysCrawlSettingRequiredKeyword(
            excludeKeyword.id,
            productId,
            pathname,
          )
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

    for (const excludeKeyword of pcKoubouCrawlSettingRequiredKeywords) {
      if (excludeKeyword.keyword === input.keyword) {
        try {
          const result = await deletePcKoubouCrawlSettingRequiredKeyword(
            excludeKeyword.id,
            productId,
            pathname,
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
      <form onSubmit={handleSubmit(onSubmit)} className='w-full space-y-2 pt-4'>
        <label className='form-control'>
          <div className='label'>
            <span className='label-text'>キーワード</span>
          </div>
          <input {...register('keyword')} className='input input-bordered' />
        </label>
        <div className='pt-4'>
          <button type='submit' className='btn btn-primary btn-md w-full'>
            すべてのプラットフォームから削除
          </button>
        </div>
      </form>
    </>
  )
}

export default DeleteForm
