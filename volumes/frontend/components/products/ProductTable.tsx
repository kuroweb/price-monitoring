'use client'

import { ApolloError } from '@apollo/client'

import { ProductQuery } from '@/graphql/dist/client'

const ProductTable = ({ data, error }: { data: ProductQuery; error: ApolloError | undefined }) => {
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
              <tr className='bg-white border-'>
                <td className='px-6 py-4'>{data.product.name}</td>
              </tr>
            </tbody>
          </table>
        </div>
      )}
    </>
  )
}

export default ProductTable
