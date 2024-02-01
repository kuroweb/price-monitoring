'use client'

import { ApolloError } from '@apollo/client'
import { useRouter } from 'next/navigation'

import { GetProductsQuery } from '@/graphql/dist/client'

const ProductsTable = ({
  data,
  error,
}: {
  data: GetProductsQuery
  error: ApolloError | undefined
}) => {
  const router = useRouter()

  const moveToDetailPage = (productId: String) => {
    router.push(`/products/${productId}`)
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
              </tr>
            </thead>
            <tbody>
              {data.products.map((product) => (
                <tr
                  onClick={() => moveToDetailPage(product.id)}
                  className='bg-white border-b hover: cursor-pointer hover:bg-gray-100'
                  key={product.id}
                >
                  <td className='px-6 py-4 select-none'>{product.name}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  )
}

export default ProductsTable
