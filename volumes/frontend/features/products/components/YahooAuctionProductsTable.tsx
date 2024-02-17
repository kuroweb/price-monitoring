'use client'

import { ApolloError } from '@apollo/client'
import NextImage from 'next/image'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const YahooAuctionProductsTable = ({
  data,
  error,
}: {
  data: GetProductDetailPageDataQuery
  error: ApolloError | undefined
}) => {
  const handleRowClick = (yahooAuctionId: String) => {
    window.open(`https://page.auctions.yahoo.co.jp/jp/auction/${yahooAuctionId}`, '_blank')
  }

  return (
    <>
      {error && <div>{error.message}</div>}
      {data && (
        <table className='w-full text-left'>
          <thead className='border-b border-base-200 uppercase'>
            <tr>
              <th className='p-4'>name</th>
              <th className='p-4'>price</th>
              <th className='p-4'>thumbnail</th>
            </tr>
          </thead>
          <tbody>
            {data.product.yahooAuctionProducts.map((product) => (
              <tr
                onClick={() => handleRowClick(product.yahooAuctionId)}
                className='border-b border-base-200 cursor-pointer hover:bg-base-100'
                key={product.id}
              >
                <td className='p-2'>{product.name}</td>
                <td className='p-2'>{product.price}</td>
                <td className='p-2'>
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
      )}
    </>
  )
}

export default YahooAuctionProductsTable
