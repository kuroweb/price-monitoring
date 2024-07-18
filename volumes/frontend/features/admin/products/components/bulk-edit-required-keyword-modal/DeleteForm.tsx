'use client'

import { useParams, useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { deleteIosysCrawlSettingRequiredKeyword } from '../../../../../server-actions/iosysCrawlSettingRequiredKeywordQuery'
import { deleteJanparaCrawlSettingRequiredKeyword } from '../../../../../server-actions/janparaCrawlSettingRequiredKeywordQuery'
import { deleteMercariCrawlSettingRequiredKeyword } from '../../../../../server-actions/mercariCrawlSettingRequiredKeywordQuery'
import { deletePcKoubouCrawlSettingRequiredKeyword } from '../../../../../server-actions/pcKoubouCrawlSettingRequiredKeywordQuery'
import { deleteUsedSofmapCrawlSettingRequiredKeyword } from '../../../../../server-actions/usedSofmapCrawlSettingRequiredKeywordQuery'
import { deleteYahooAuctionCrawlSettingRequiredKeyword } from '../../../../../server-actions/yahooAuctionCrawlSettingRequiredKeywordQuery'
import { useBulkEditRequiredKeywordModalState } from '../../hooks/useBulkEditRequiredKeywordModalState'

import type { ProductsIdPageDataQuery } from '@/graphql/dist/client'
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
  usedSofmapCrawlSettingRequiredKeywords,
}: {
  yahooAuctionCrawlSettingRequiredKeywords: ProductsIdPageDataQuery['product']['yahooAuctionCrawlSetting']['yahooAuctionCrawlSettingRequiredKeywords']
  mercariCrawlSettingRequiredKeywords: ProductsIdPageDataQuery['product']['mercariCrawlSetting']['mercariCrawlSettingRequiredKeywords']
  janparaCrawlSettingRequiredKeywords: ProductsIdPageDataQuery['product']['janparaCrawlSetting']['janparaCrawlSettingRequiredKeywords']
  iosysCrawlSettingRequiredKeywords: ProductsIdPageDataQuery['product']['iosysCrawlSetting']['iosysCrawlSettingRequiredKeywords']
  pcKoubouCrawlSettingRequiredKeywords: ProductsIdPageDataQuery['product']['pcKoubouCrawlSetting']['pcKoubouCrawlSettingRequiredKeywords']
  usedSofmapCrawlSettingRequiredKeywords: ProductsIdPageDataQuery['product']['usedSofmapCrawlSetting']['usedSofmapCrawlSettingRequiredKeywords']
}) => {
  const router = useRouter()
  const params = useParams()

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
          const result = await deleteYahooAuctionCrawlSettingRequiredKeyword({
            id: excludeKeyword.id,
            productId,
          })
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
          const result = await deleteMercariCrawlSettingRequiredKeyword({
            id: excludeKeyword.id,
            productId,
          })
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
          const result = await deleteJanparaCrawlSettingRequiredKeyword({
            id: excludeKeyword.id,
            productId,
          })
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
          const result = await deleteIosysCrawlSettingRequiredKeyword({
            id: excludeKeyword.id,
            productId,
          })
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
          const result = await deletePcKoubouCrawlSettingRequiredKeyword({
            id: excludeKeyword.id,
            productId,
          })
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

    for (const excludeKeyword of usedSofmapCrawlSettingRequiredKeywords) {
      if (excludeKeyword.keyword === input.keyword) {
        try {
          const result = await deleteUsedSofmapCrawlSettingRequiredKeyword({
            id: excludeKeyword.id,
            productId,
          })
          if (
            result?.data?.deleteUsedSofmapCrawlSettingRequiredKeyword.__typename ===
              'DeleteUsedSofmapCrawlSettingRequiredKeywordResultError' &&
            result?.data?.deleteUsedSofmapCrawlSettingRequiredKeyword.error.code !== '404'
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
