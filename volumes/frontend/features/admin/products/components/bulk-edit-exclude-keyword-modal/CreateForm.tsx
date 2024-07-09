'use client'

import { useParams, useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { createIosysCrawlSettingExcludeKeyword } from '../../../../../server-actions/iosysCrawlSettingExcludeKeywordQuery'
import { createJanparaCrawlSettingExcludeKeyword } from '../../../../../server-actions/janparaCrawlSettingExcludeKeywordQuery'
import { createMercariCrawlSettingExcludeKeyword } from '../../../../../server-actions/mercariCrawlSettingExcludeKeywordQuery'
import { createPcKoubouCrawlSettingExcludeKeyword } from '../../../../../server-actions/pcKoubouCrawlSettingExcludeKeywordQuery'
import { createUsedSofmapCrawlSettingExcludeKeyword } from '../../../../../server-actions/usedSofmapCrawlSettingExcludeKeywordQuery'
import { createYahooAuctionCrawlSettingExcludeKeyword } from '../../../../../server-actions/yahooAuctionCrawlSettingExcludeKeywordQuery'
import { useBulkEditExcludeKeywordModalState } from '../../hooks/useBulkEditExcludeKeywordModalState'

import type { SubmitHandler } from 'react-hook-form'

type inputType = {
  keyword: string | null
}

const CreateForm = () => {
  const router = useRouter()
  const params = useParams()

  const [_, setModal] = useBulkEditExcludeKeywordModalState()
  const { register, handleSubmit, setValue } = useForm<inputType>({
    defaultValues: {
      keyword: null,
    },
  })

  const onSubmit: SubmitHandler<inputType> = async (input) => {
    bulkCreate(input)
  }

  const bulkCreate = async (input: inputType) => {
    const postData = {
      productId: String(params.id),
      keyword: input.keyword,
    }

    const yahooAuctionResult = await createYahooAuctionCrawlSettingExcludeKeyword(postData)
    if (
      yahooAuctionResult?.data?.createYahooAuctionCrawlSettingExcludeKeyword.__typename ===
        'CreateYahooAuctionCrawlSettingExcludeKeywordResultError' &&
      yahooAuctionResult?.data?.createYahooAuctionCrawlSettingExcludeKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const mercariResult = await createMercariCrawlSettingExcludeKeyword(postData)
    if (
      mercariResult?.data?.createMercariCrawlSettingExcludeKeyword.__typename ===
        'CreateMercariCrawlSettingExcludeKeywordResultError' &&
      mercariResult?.data?.createMercariCrawlSettingExcludeKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const janparaResult = await createJanparaCrawlSettingExcludeKeyword(postData)
    if (
      janparaResult?.data?.createJanparaCrawlSettingExcludeKeyword.__typename ===
        'CreateJanparaCrawlSettingExcludeKeywordResultError' &&
      janparaResult?.data?.createJanparaCrawlSettingExcludeKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const iosysResult = await createIosysCrawlSettingExcludeKeyword(postData)
    if (
      iosysResult?.data?.createIosysCrawlSettingExcludeKeyword.__typename ===
        'CreateIosysCrawlSettingExcludeKeywordResultError' &&
      iosysResult?.data?.createIosysCrawlSettingExcludeKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const pcKoubouResult = await createPcKoubouCrawlSettingExcludeKeyword(postData)
    if (
      pcKoubouResult?.data?.createPcKoubouCrawlSettingExcludeKeyword.__typename ===
        'CreatePcKoubouCrawlSettingExcludeKeywordResultError' &&
      pcKoubouResult?.data?.createPcKoubouCrawlSettingExcludeKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const usedSofmapResult = await createUsedSofmapCrawlSettingExcludeKeyword(postData)
    if (
      usedSofmapResult?.data?.createUsedSofmapCrawlSettingExcludeKeyword.__typename ===
        'CreateUsedSofmapCrawlSettingExcludeKeywordResultError' &&
      usedSofmapResult?.data?.createUsedSofmapCrawlSettingExcludeKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    setModal(false)
    setValue('keyword', null)
    toast.success('一括登録に成功しました。')
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
            すべてのプラットフォームに追加
          </button>
        </div>
      </form>
    </>
  )
}

export default CreateForm
