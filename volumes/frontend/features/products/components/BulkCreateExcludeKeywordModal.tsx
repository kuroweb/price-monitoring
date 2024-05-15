'use client'

import { useParams, useRouter } from 'next/navigation'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useBulkCreateExcludeKeywordModalState } from '../hooks/useBulkCreateExcludeKeywordModalState'
import {
  createIosysCrawlSettingExcludeKeyword,
  createJanparaCrawlSettingExcludeKeyword,
  createMercariCrawlSettingExcludeKeyword,
  createPcKoubouCrawlSettingExcludeKeyword,
  createYahooAuctionCrawlSettingExcludeKeyword,
} from '../server-actions/productQuery'

type inputType = {
  keyword: string | null
}

const BulkCreateExcludeKeywordModal = () => {
  const router = useRouter()
  const params = useParams()

  const [modal, setModal] = useBulkCreateExcludeKeywordModalState()
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

    setModal(false)
    setValue('keyword', null)
    toast.success('一括登録に成功しました。')
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
          <h3 className='font-bold text-lg'>除外キーワード（一括登録）</h3>
          <form onSubmit={handleSubmit(onSubmit)} className='w-full space-y-2 pt-4'>
            <label className='form-control'>
              <div className='label'>
                <span className='label-text'>キーワード</span>
              </div>
              <input {...register('keyword')} className='input input-bordered' />
            </label>
            <div className='pt-4'>
              <button type='submit' className='btn btn-md btn-primary w-full'>
                すべてのプラットフォームに追加
              </button>
            </div>
          </form>
        </div>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default BulkCreateExcludeKeywordModal
