'use client'

import NextImage from 'next/image'

import { usePublishedState } from '../hooks/usePublishedState'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const YahooAuctionProductsTable = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const [published, _] = usePublishedState()

  const handleRowClick = (yahooAuctionId: String) => {
    window.open(`https://page.auctions.yahoo.co.jp/jp/auction/${yahooAuctionId}`, '_blank')
  }

  const parseDate = (date: string | null | undefined) => {
    // 暫定実装
    return date ? date.substring(0, 10) : ''
  }

  return (
    <>
      {data && (
        <>
          <table className='table'>
            <thead>
              <tr>
                <th>商品名</th>
                <th>価格</th>
                {!published && <th className='w-28'>購入日</th>}
                <th className='w-24'></th>
              </tr>
            </thead>
            <tbody>
              {data.product.yahooAuctionProducts.map((product) => (
                <tr
                  key={product.id}
                  onClick={() => handleRowClick(product.yahooAuctionId)}
                  className='border-b border-base-200 cursor-pointer hover:bg-base-100'
                >
                  <td className='p-2'>{product.name}</td>
                  <td className='p-2'>{product.price}</td>
                  {!published && <td className='p-2'>{parseDate(product.boughtDate)}</td>}
                  <td className='p-0 md:p-2'>
                    <div className='relative aspect-square'>
                      <NextImage
                        className='object-contain'
                        src={product.thumbnailUrl}
                        alt=''
                        fill
                        sizes='100vw, 100vw'
                      />
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
    </>
  )
}

export default YahooAuctionProductsTable
