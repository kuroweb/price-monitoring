'use client'

import { useState } from 'react'

import { Join } from 'react-daisyui'

import { useBulkEditExcludeKeywordModalState } from '../../hooks/useBulkEditExcludeKeywordModalState'

import CreateForm from './CreateForm'
import DeleteForm from './DeleteForm'

import type { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const BulkEditExcludeKeywordModal = ({
  yahooAuctionCrawlSettingExcludeKeywords,
  mercariCrawlSettingExcludeKeywords,
  janparaCrawlSettingExcludeKeywords,
  iosysCrawlSettingExcludeKeywords,
  pcKoubouCrawlSettingExcludeKeywords,
}: {
  yahooAuctionCrawlSettingExcludeKeywords: GetProductDetailPageDataQuery['product']['yahooAuctionCrawlSetting']['yahooAuctionCrawlSettingExcludeKeywords']
  mercariCrawlSettingExcludeKeywords: GetProductDetailPageDataQuery['product']['mercariCrawlSetting']['mercariCrawlSettingExcludeKeywords']
  janparaCrawlSettingExcludeKeywords: GetProductDetailPageDataQuery['product']['janparaCrawlSetting']['janparaCrawlSettingExcludeKeywords']
  iosysCrawlSettingExcludeKeywords: GetProductDetailPageDataQuery['product']['iosysCrawlSetting']['iosysCrawlSettingExcludeKeywords']
  pcKoubouCrawlSettingExcludeKeywords: GetProductDetailPageDataQuery['product']['pcKoubouCrawlSetting']['pcKoubouCrawlSettingExcludeKeywords']
}) => {
  const [tab, setTab] = useState<'一括登録' | '一括削除'>('一括登録')
  const [modal, setModal] = useBulkEditExcludeKeywordModalState()

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
          <h3 className='text-lg font-bold'>除外キーワード</h3>
          <Join className='flex pt-8'>
            <input
              className='btn join-item btn-md w-1/2'
              type='radio'
              name='bulk_edit_exclude_keyword_options'
              aria-label='一括登録'
              checked={tab == '一括登録'}
              onChange={() => setTab('一括登録')}
            />
            <input
              className='btn join-item btn-md w-1/2'
              type='radio'
              name='bulk_edit_exclude_keyword_options'
              aria-label='一括削除'
              checked={tab == '一括削除'}
              onChange={() => setTab('一括削除')}
            />
          </Join>
          <div>
            {tab == '一括登録' && <CreateForm />}
            {tab == '一括削除' && (
              <DeleteForm
                yahooAuctionCrawlSettingExcludeKeywords={yahooAuctionCrawlSettingExcludeKeywords}
                mercariCrawlSettingExcludeKeywords={mercariCrawlSettingExcludeKeywords}
                janparaCrawlSettingExcludeKeywords={janparaCrawlSettingExcludeKeywords}
                iosysCrawlSettingExcludeKeywords={iosysCrawlSettingExcludeKeywords}
                pcKoubouCrawlSettingExcludeKeywords={pcKoubouCrawlSettingExcludeKeywords}
              />
            )}
          </div>
        </div>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default BulkEditExcludeKeywordModal
