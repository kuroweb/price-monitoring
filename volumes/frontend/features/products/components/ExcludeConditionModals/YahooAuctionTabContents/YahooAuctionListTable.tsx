'use client'

import { Table } from 'react-daisyui'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const YahooAuctionListTable = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  return (
    <>
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
    </>
  )
}

export default YahooAuctionListTable
