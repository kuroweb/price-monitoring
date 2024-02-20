'use client'

import { useCallback, useRef, useState } from 'react'

import { Button, Join, Modal, Table } from 'react-daisyui'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const UpdateExcludeConditionModal = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const [tab, setTab] = useState<'ヤフオク' | 'メルカリ' | 'ペイペイ'>('ヤフオク')

  const ref = useRef<HTMLDialogElement>(null)
  const showListModal = useCallback(() => {
    ref.current?.showModal()
  }, [ref])
    ref.current?.showModal()
  }, [ref])

  return (
    <>
      <Button onClick={showListModal} className='no-animation'>
        除外条件
      </Button>
      <Modal ref={ref} backdrop={true}>
        <Modal.Header className='font-bold'>
          除外条件
          <form method='dialog'>
            <Button size='sm' color='ghost' shape='circle' className='absolute right-2 top-2'>
              ✕
            </Button>
          </form>
        </Modal.Header>
        <Modal.Body>
          <div className='pb-6'>
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
            {/* TODO: 一覧表示を作成したところ。今後、追加・更新・削除ができるようにしていく */}
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
        </Modal.Body>
      </Modal>
    </>
  )
}

export default UpdateExcludeConditionModal
