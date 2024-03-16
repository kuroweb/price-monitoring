'use client'

import { useEffect, useState } from 'react'

import NextImage from 'next/image'
import { useParams, useSearchParams } from 'next/navigation'

import {
  fetchMercariProductsTableData,
  mercariProductsTableResponse,
} from '../server-actions/query'

const MercariProductsTable = () => {
  // params
  const params = useParams()
  const searchParams = useSearchParams()
  const productId = String(params.id)
  const published = searchParams.get('published') ? searchParams.get('published') === 'true' : true

  // state
  const [data, setData] = useState<mercariProductsTableResponse | null>(null)

  useEffect(() => {
    const fetchData = async () => {
      const { data } = await fetchMercariProductsTableData(productId, published)
      setData(data)
    }
    fetchData()
  }, [productId, published])

  const handleRowClick = (mercariId: String) => {
    window.open(`https://jp.mercari.com/item/${mercariId}`, '_blank')
  }

  return (
    <>
      {data && (
        <>
          <table className='table'>
            <thead>
              <tr>
                <th>name</th>
                <th>price</th>
                <th>thumbnail</th>
              </tr>
            </thead>
            <tbody>
              {data.product.mercariProducts.map((product) => (
                <tr
                  key={product.id}
                  onClick={() => handleRowClick(product.mercariId)}
                  className='border-b border-base-200 cursor-pointer hover:bg-base-100'
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
        </>
      )}
    </>
  )
}

export default MercariProductsTable
