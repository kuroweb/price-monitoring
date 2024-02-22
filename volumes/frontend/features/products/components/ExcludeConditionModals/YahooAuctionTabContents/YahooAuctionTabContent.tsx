import { useState } from 'react'

import { Button } from 'react-daisyui'

import CreateYahooAuctionForm from './CreateYahooAuctionForm'
import YahooAuctionListTable from './YahooAuctionListTable'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const YahooAuctionTabContent = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const [mode, setMode] = useState<'list' | 'create' | 'edit'>('list')

  return (
    <>
      <div className='space-y-4'>
        {mode == 'list' && (
          <>
            <Button onClick={() => setMode('create')} color='neutral' size='md' className='w-full'>
              ＋ 除外条件を追加
            </Button>
            <YahooAuctionListTable data={data} />
          </>
        )}
        {mode == 'create' && (
          <>
            <Button onClick={() => setMode('list')} color='neutral' size='md' className='w-full'>
              ＜ 一覧に戻る
            </Button>
            <CreateYahooAuctionForm setMode={setMode} />
          </>
        )}
      </div>
    </>
  )
}

export default YahooAuctionTabContent
