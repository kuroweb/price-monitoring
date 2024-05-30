'use client'

import { useState } from 'react'

import { Join } from 'react-daisyui'

import { useBulkEditRequiredKeywordModalState } from '../../hooks/useBulkEditRequiredKeywordModalState'

import CreateForm from './CreateForm'
import DeleteForm from './DeleteForm'

import type { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const BulkEditRequiredKeywordModal = ({
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
  const [tab, setTab] = useState<'一括登録' | '一括削除'>('一括登録')
  const [modal, setModal] = useBulkEditRequiredKeywordModalState()

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
            className='btn btn-circle btn-ghost btn-sm absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='text-lg font-bold'>必須キーワード</h3>
          <Join className='flex pt-8'>
            <input
              className='btn join-item btn-md w-1/2'
              type='radio'
              name='bulk_edit_required_keyword_options'
              aria-label='一括登録'
              checked={tab == '一括登録'}
              onChange={() => setTab('一括登録')}
            />
            <input
              className='btn join-item btn-md w-1/2'
              type='radio'
              name='bulk_edit_required_keyword_options'
              aria-label='一括削除'
              checked={tab == '一括削除'}
              onChange={() => setTab('一括削除')}
            />
          </Join>
          <div>
            {tab == '一括登録' && <CreateForm />}
            {tab == '一括削除' && (
              <DeleteForm
                yahooAuctionCrawlSettingRequiredKeywords={yahooAuctionCrawlSettingRequiredKeywords}
                mercariCrawlSettingRequiredKeywords={mercariCrawlSettingRequiredKeywords}
                janparaCrawlSettingRequiredKeywords={janparaCrawlSettingRequiredKeywords}
                iosysCrawlSettingRequiredKeywords={iosysCrawlSettingRequiredKeywords}
                pcKoubouCrawlSettingRequiredKeywords={pcKoubouCrawlSettingRequiredKeywords}
              />
            )}
          </div>
        </div>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default BulkEditRequiredKeywordModal
