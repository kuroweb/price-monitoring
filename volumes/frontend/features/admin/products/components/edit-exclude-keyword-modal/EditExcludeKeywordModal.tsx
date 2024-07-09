'use client'

import { useState } from 'react'

import { Join } from 'react-daisyui'

import { useEditExcludeKeywordModalState } from '../../hooks/useEditExcludeKeywordModalState'

import IosysTab from './iosys-tab/IosysTab'
import JanparaTab from './janpara-tab/JanparaTab'
import MercariTab from './mercari-tab/MercariTab'
import PcKoubouTab from './pc-koubou-tab/PcKoubouTab'
import UsedSofmapTab from './used-sofmap-tab/UsedSofmapTab'
import YahooAuctionTab from './yahoo-auction-tab/YahooAuctionTab'

import type { GetProductSettingPageDataQuery } from '@/graphql/dist/client'

const ExcludeKeywordModal = ({ data }: { data: GetProductSettingPageDataQuery }) => {
  const [tab, setTab] = useState<
    'ヤフオク' | 'メルカリ' | 'じゃんぱら' | 'イオシス' | 'パソコン工房' | 'リコレ'
  >('ヤフオク')
  const [modal, setModal] = useEditExcludeKeywordModalState()

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
          <div className='py-6'>
            <Join className='flex pb-2'>
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='exclude_keyword'
                aria-label='ヤフオク'
                checked={tab == 'ヤフオク'}
                onChange={() => setTab('ヤフオク')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='exclude_keyword'
                aria-label='メルカリ'
                checked={tab == 'メルカリ'}
                onChange={() => setTab('メルカリ')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='exclude_keyword'
                aria-label='じゃんぱら'
                checked={tab == 'じゃんぱら'}
                onChange={() => setTab('じゃんぱら')}
              />
            </Join>
            <Join className='flex'>
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='exclude_keyword'
                aria-label='イオシス'
                checked={tab == 'イオシス'}
                onChange={() => setTab('イオシス')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='exclude_keyword'
                aria-label='パソコン工房'
                checked={tab == 'パソコン工房'}
                onChange={() => setTab('パソコン工房')}
              />
              <input
                className='btn join-item btn-md w-1/3'
                type='radio'
                name='exclude_keyword'
                aria-label='リコレ'
                checked={tab == 'リコレ'}
                onChange={() => setTab('リコレ')}
              />
            </Join>
          </div>
          <div>
            {tab == 'ヤフオク' && <YahooAuctionTab data={data} />}
            {tab == 'メルカリ' && <MercariTab data={data} />}
            {tab == 'じゃんぱら' && <JanparaTab data={data} />}
            {tab == 'イオシス' && <IosysTab data={data} />}
            {tab == 'パソコン工房' && <PcKoubouTab data={data} />}
            {tab == 'リコレ' && <UsedSofmapTab data={data} />}
          </div>
        </div>

        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default ExcludeKeywordModal
