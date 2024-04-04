'use client'

import NextImage from 'next/image'

import { usePublishedState } from '../hooks/usePublishedState'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const MercariProductsTable = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const [published, _] = usePublishedState()

  const handleRowClick = (mercariId: string) => {
    window.open(`https://jp.mercari.com/item/${mercariId}`, '_blank')
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
                {!published && <th>購入日</th>}
                <th></th>
              </tr>
            </thead>
            <tbody>
              {data.product.mercariProducts.map((product) => (
                <tr
                  key={product.id}
                  onClick={() => handleRowClick(product.mercariId)}
                  className='border-b border-base-200 cursor-pointer hover:bg-base-100'
                >
                  <td className='p-2 w-36 max-w-36 md:w-full md:max-w-full'>{product.name}</td>
                  <td className='p-2 w-16 min-w-16'>{product.price}</td>
                  {!published && (
                    <td className='p-2 w-24 min-w-24 md:w-28 md:min-w-28'>
                      {parseDate(product.boughtDate)}
                    </td>
                  )}
                  <td className='p-2 w-20 min-w-20 md:w-24 md:min-w-24'>
                    <div className='relative aspect-square'>
                      <NextImage
                        className='object-cover rounded-lg'
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

export default MercariProductsTable
