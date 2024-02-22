'use client'

import { useCallback, useRef, useState } from 'react'

import { Button, Join, Modal } from 'react-daisyui'

import CreateYahooAuctionForm from './CreateYahooAuctionForm'
import YahooAuctionListTable from './YahooAuctionListTable'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const ExcludeConditionModal = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const [modal, setModal] = useState<boolean>(false)
  const [tab, setTab] = useState<'ヤフオク' | 'メルカリ' | 'ペイペイ'>('ヤフオク')

  // TODO: 複数モーダルは煩雑になりそう && 実現に時間がかかりそうなので撤退
  //       モーダル内の表示を「登録モード・編集モード」に切り替えるパターンで対応中
  return (
    <>
      <div onClick={() => setModal(true)} className='btn no-animation'>
        除外条件
      </div>
      <input
        type='checkbox'
        className='modal-toggle'
        checked={modal}
        onChange={(e) => setModal(e.target.checked)}
      />
      <div className='modal' role='dialog'>
        <div className='modal-box'>
          <div
            onClick={() => setModal(false)}
            className='btn btn-sm btn-circle btn-ghost absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='font-bold text-lg'>除外条件</h3>
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
          <div className=''>
            {/* TODO: 一覧表示を作成したところ。今後、追加・更新・削除ができるようにしていく */}
            {tab == 'ヤフオク' && (
              <div className='space-y-4'>
                <Button color='neutral' size='md' className='w-full'>
                  ＋ 除外条件を追加
                </Button>
                <CreateYahooAuctionForm />
                <YahooAuctionListTable data={data} />
              </div>
            )}
            {tab == 'メルカリ' && <div>メルカリ</div>}
            {tab == 'ペイペイ' && <div>ペイペイ</div>}
          </div>
        </div>

        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default ExcludeConditionModal
