'use client'

import { useState } from 'react'

import { Join, Table } from 'react-daisyui'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const UpdateExcludeConditionModal = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const [modal, setModal] = useState<boolean>(false)
  const [tab, setTab] = useState<'ヤフオク' | 'メルカリ' | 'ペイペイ'>('ヤフオク')

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
                className='join-item btn btn-sm w-1/3'
                type='radio'
                name='options'
                aria-label='ヤフオク'
                checked={tab == 'ヤフオク'}
                onChange={() => setTab('ヤフオク')}
              />
              <input
                className='join-item btn btn-sm w-1/3'
                type='radio'
                name='options'
                aria-label='メルカリ'
                checked={tab == 'メルカリ'}
                onChange={() => setTab('メルカリ')}
              />
              <input
                className='join-item btn btn-sm w-1/3'
                type='radio'
                name='options'
                aria-label='ペイペイ'
                checked={tab == 'ペイペイ'}
                onChange={() => setTab('ペイペイ')}
              />
            </Join>
          </div>
          <div className=''>
            {tab == 'ヤフオク' && (
              <div>
                <Table>
                  <Table.Head>
                    <span>キーワード</span>
                    <span>商品ID</span>
                    <span>出品者ID</span>
                  </Table.Head>
                  <Table.Body>
                    {data.product.yahooAuctionCrawlSetting.yahooAuctionCrawlSettingExcludeConditions.map(
                      (row) => (
                        <Table.Row key={row.id}>
                          <span>{row.keyword}</span>
                          <span>{row.yahooAuctionId}</span>
                          <span>{row.sellerId}</span>
                        </Table.Row>
                      ),
                    )}
                  </Table.Body>
                </Table>
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

export default UpdateExcludeConditionModal
