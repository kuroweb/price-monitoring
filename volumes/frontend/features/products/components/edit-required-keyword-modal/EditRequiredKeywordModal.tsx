'use client'

import { useState } from 'react'

import { Join } from 'react-daisyui'

import { useEditRequiredKeywordModalState } from '../../hooks/useEditRequiredKeywordModalState'

import IosysTab from './iosys-tab/IosysTab'
import JanparaTab from './janpara-tab/JanparaTab'
import MercariTab from './mercari-tab/MercariTab'
import YahooAuctionTab from './yahoo-auction-tab/YahooAuctionTab'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const RequiredKeywordModal = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const [tab, setTab] = useState<'ヤフオク' | 'メルカリ' | 'じゃんぱら' | 'イオシス'>('ヤフオク')
  const [modal, setModal] = useEditRequiredKeywordModalState()

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
          <h3 className='font-bold text-lg'>必須キーワード</h3>
          <div className='py-6'>
            <Join className='flex'>
              <input
                className='join-item btn btn-md w-1/4'
                type='radio'
                name='required_keyword'
                aria-label='ヤフオク'
                checked={tab == 'ヤフオク'}
                onChange={() => setTab('ヤフオク')}
              />
              <input
                className='join-item btn btn-md w-1/4'
                type='radio'
                name='required_keyword'
                aria-label='メルカリ'
                checked={tab == 'メルカリ'}
                onChange={() => setTab('メルカリ')}
              />
              <input
                className='join-item btn btn-md w-1/4'
                type='radio'
                name='required_keyword'
                aria-label='じゃんぱら'
                checked={tab == 'じゃんぱら'}
                onChange={() => setTab('じゃんぱら')}
              />
              <input
                className='join-item btn btn-md w-1/4'
                type='radio'
                name='required_keyword'
                aria-label='イオシス'
                checked={tab == 'イオシス'}
                onChange={() => setTab('イオシス')}
              />
            </Join>
          </div>
          <div>
            {tab == 'ヤフオク' && <YahooAuctionTab data={data} />}
            {tab == 'メルカリ' && <MercariTab data={data} />}
            {tab == 'じゃんぱら' && <JanparaTab data={data} />}
            {tab == 'イオシス' && <IosysTab data={data} />}
          </div>
        </div>

        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default RequiredKeywordModal
