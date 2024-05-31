'use client'

import { useParams, usePathname, useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useBulkEditRequiredKeywordModalState } from '../../hooks/useBulkEditRequiredKeywordModalState'
import { createIosysCrawlSettingRequiredKeyword } from '../../server-actions/iosysCrawlSettingRequiredKeywordQuery'
import { createJanparaCrawlSettingRequiredKeyword } from '../../server-actions/janparaCrawlSettingRequiredKeywordQuery'
import { createMercariCrawlSettingRequiredKeyword } from '../../server-actions/mercariCrawlSettingRequiredKeywordQuery'
import { createPcKoubouCrawlSettingRequiredKeyword } from '../../server-actions/pcKoubouCrawlSettingRequiredKeywordQuery'
import { createYahooAuctionCrawlSettingRequiredKeyword } from '../../server-actions/yahooAuctionCrawlSettingRequiredKeywordQuery'

import type { SubmitHandler } from 'react-hook-form'

type inputType = {
  keyword: string | null
}

const CreateForm = () => {
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
    bulkCreate(input)
  }

  const bulkCreate = async (input: inputType) => {
    const postData = {
      productId: String(params.id),
      keyword: input.keyword,
    }

    const yahooAuctionResult = await createYahooAuctionCrawlSettingRequiredKeyword(
      postData,
      pathname,
    )
    if (
      yahooAuctionResult?.data?.createYahooAuctionCrawlSettingRequiredKeyword.__typename ===
        'CreateYahooAuctionCrawlSettingRequiredKeywordResultError' &&
      yahooAuctionResult?.data?.createYahooAuctionCrawlSettingRequiredKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const mercariResult = await createMercariCrawlSettingRequiredKeyword(postData, pathname)
    if (
      mercariResult?.data?.createMercariCrawlSettingRequiredKeyword.__typename ===
        'CreateMercariCrawlSettingRequiredKeywordResultError' &&
      mercariResult?.data?.createMercariCrawlSettingRequiredKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const janparaResult = await createJanparaCrawlSettingRequiredKeyword(postData, pathname)
    if (
      janparaResult?.data?.createJanparaCrawlSettingRequiredKeyword.__typename ===
        'CreateJanparaCrawlSettingRequiredKeywordResultError' &&
      janparaResult?.data?.createJanparaCrawlSettingRequiredKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const iosysResult = await createIosysCrawlSettingRequiredKeyword(postData, pathname)
    if (
      iosysResult?.data?.createIosysCrawlSettingRequiredKeyword.__typename ===
        'CreateIosysCrawlSettingRequiredKeywordResultError' &&
      iosysResult?.data?.createIosysCrawlSettingRequiredKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const pcKoubouResult = await createPcKoubouCrawlSettingRequiredKeyword(postData, pathname)
    if (
      pcKoubouResult?.data?.createPcKoubouCrawlSettingRequiredKeyword.__typename ===
        'CreatePcKoubouCrawlSettingRequiredKeywordResultError' &&
      pcKoubouResult?.data?.createPcKoubouCrawlSettingRequiredKeyword.error.code !== '409'
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
