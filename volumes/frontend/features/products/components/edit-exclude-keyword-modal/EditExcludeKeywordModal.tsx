'use client'

import { useState } from 'react'

import { usePathname, useRouter, useSearchParams } from 'next/navigation'
import { Join } from 'react-daisyui'

import {
  useEditExcludeKeywordModalQuery,
  useEditExcludeKeywordModalState,
} from '../../hooks/useEditExcludeKeywordModalState'

import YahooAuctionTab from './yahoo-auction-tab/YahooAuctionTab'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const ExcludeKeywordModal = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const router = useRouter()
  const pathname = usePathname()
  const searchParams = useSearchParams()
  const urlSearchParams = new URLSearchParams(searchParams)

  const [tab, setTab] = useState<'ヤフオク' | 'メルカリ' | 'ペイペイ'>('ヤフオク')
  const [modal, setModal] = useEditExcludeKeywordModalState()

  const closeModal = () => {
    setModal(false)
    urlSearchParams.set(useEditExcludeKeywordModalQuery, 'false')
    router.replace(`${pathname}?${urlSearchParams.toString()}`)
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
        <div className='modal-box h-3/4 md:h-1/2'>
          <div
            onClick={closeModal}
            className='btn btn-sm btn-circle btn-ghost absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='font-bold text-lg'>除外キーワード</h3>
          <div className='py-6'>
            <Join className='flex'>
              <input
                className='join-item btn btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='ヤフオク'
                checked={tab == 'ヤフオク'}
                onChange={() => setTab('ヤフオク')}
              />
              <input
                className='join-item btn btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='メルカリ'
                checked={tab == 'メルカリ'}
                onChange={() => setTab('メルカリ')}
              />
              <input
                className='join-item btn btn-md w-1/3'
                type='radio'
                name='options'
                aria-label='ペイペイ'
                checked={tab == 'ペイペイ'}
                onChange={() => setTab('ペイペイ')}
              />
            </Join>
          </div>
          <div>
            {tab == 'ヤフオク' && <YahooAuctionTab data={data} />}
            {tab == 'メルカリ' && <div>メルカリ</div>}
            {tab == 'ペイペイ' && <div>ペイペイ</div>}
          </div>
        </div>

        <div onClick={closeModal} className='modal-backdrop' />
      </div>
    </>
  )
}

export default ExcludeKeywordModal
