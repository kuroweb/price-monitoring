'use client'

import { useParams, useRouter } from 'next/navigation'
import { SubmitHandler, useForm } from 'react-hook-form'
import { toast } from 'react-toastify'

import { useBulkCreateRequiredKeywordModalState } from '../hooks/useBulkCreateRequiredKeywordModalState'
import {
  createIosysCrawlSettingRequiredKeyword,
  createJanparaCrawlSettingRequiredKeyword,
  createMercariCrawlSettingRequiredKeyword,
  createPcKoubouCrawlSettingRequiredKeyword,
  createYahooAuctionCrawlSettingRequiredKeyword,
} from '../server-actions/productQuery'

type inputType = {
  productId: string
  keyword: string | null
}

const BulkCreateRequiredKeywordModal = () => {
  const router = useRouter()
  const params = useParams()

  const [modal, setModal] = useBulkCreateRequiredKeywordModalState()
  const { register, handleSubmit, setValue } = useForm<inputType>({
    defaultValues: {
      productId: String(params.id),
      keyword: null,
    },
  })

  const onSubmit: SubmitHandler<inputType> = async (data) => {
    bulkCreate(data)
  }

  const bulkCreate = async (data: inputType) => {
    const yahooAuctionResult = await createYahooAuctionCrawlSettingRequiredKeyword(data)
    if (
      yahooAuctionResult?.data?.createYahooAuctionCrawlSettingRequiredKeyword.__typename ===
        'CreateYahooAuctionCrawlSettingRequiredKeywordResultError' &&
      yahooAuctionResult?.data?.createYahooAuctionCrawlSettingRequiredKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const mercariResult = await createMercariCrawlSettingRequiredKeyword(data)
    if (
      mercariResult?.data?.createMercariCrawlSettingRequiredKeyword.__typename ===
        'CreateMercariCrawlSettingRequiredKeywordResultError' &&
      mercariResult?.data?.createMercariCrawlSettingRequiredKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const janparaResult = await createJanparaCrawlSettingRequiredKeyword(data)
    if (
      janparaResult?.data?.createJanparaCrawlSettingRequiredKeyword.__typename ===
        'CreateJanparaCrawlSettingRequiredKeywordResultError' &&
      janparaResult?.data?.createJanparaCrawlSettingRequiredKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const iosysResult = await createIosysCrawlSettingRequiredKeyword(data)
    if (
      iosysResult?.data?.createIosysCrawlSettingRequiredKeyword.__typename ===
        'CreateIosysCrawlSettingRequiredKeywordResultError' &&
      iosysResult?.data?.createIosysCrawlSettingRequiredKeyword.error.code !== '409'
    ) {
      return toast.error('一括登録に失敗しました。')
    }

    const pcKoubouResult = await createPcKoubouCrawlSettingRequiredKeyword(data)
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
          <h3 className='font-bold text-lg'>必須キーワード（一括登録）</h3>
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

export default BulkCreateRequiredKeywordModal
