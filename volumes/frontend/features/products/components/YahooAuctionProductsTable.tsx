'use client'

import { ApolloError } from '@apollo/client'
import NextImage from 'next/image'

import { GetProductWithAssociationQuery } from '@/graphql/dist/client'

const YahooAuctionProductsTable = ({
  data,
  error,
}: {
  data: GetProductWithAssociationQuery
  error: ApolloError | undefined
}) => {
  const handleRowClick = (yahooAuctionId: String) => {
    window.open(`https://page.auctions.yahoo.co.jp/jp/auction/${yahooAuctionId}`, '_blank')
  }

  return (
    <>
      {error && <div>{error.message}</div>}
      {data && (
        <div className='relative overflow-x-auto shadow-md rounded-lg'>
          <table className='w-full text-sm text-left text-gray-500'>
            <thead className='text-xs text-gray-700 uppercase bg-gray-50'>
              <tr>
                <th scope='col' className='px-6 py-3'>
                  name
                </th>
                <th scope='col' className='px-6 py-3'>
                  price
                </th>
                <th scope='col' className='px-6 py-3'>
                  thumbnail
                </th>
              </tr>
            </thead>
            <tbody>
              {data.product.yahooAuctionProducts.map((product) => (
                <tr
                  onClick={() => handleRowClick(product.yahooAuctionId)}
                  className='bg-white border-b hover: cursor-pointer hover:bg-gray-100'
                  key={product.id}
                >
                  <td className='px-6 py-4'>{product.name}</td>
                  <td className='px-6 py-4'>{product.price}</td>
                  <td className='px-6 py-4'>
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
        </div>
      )}
    </>
  )
}

export default YahooAuctionProductsTable
