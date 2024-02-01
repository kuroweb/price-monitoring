'use client'

import { ApolloError } from '@apollo/client'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { deleteProduct } from '../actions/submit'

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

  const submitDeleteProduct = async (productId: String) => {
    const result = await deleteProduct(productId)

    if (result.data?.deleteProduct.ok) {
      toast.success('success')
    } else {
      toast.error('error')
    }
  }

  return (
    <>
      {error && <div>{error.message}</div>}
      {data && (
        <div className='relative overflow-x-auto shadow-md rounded-lg'>
          <table className='w-full text-sm text-left text-gray-500'>
            <thead className='text-xs text-gray-700 uppercase bg-gray-50'>
              <tr>
                <th className='px-6 py-3'>name</th>
              </tr>
            </thead>
            <tbody>
              {data.products.map((product) => (
                <tr
                  key={product.id}
                  className='bg-white border-b hover: cursor-pointer hover:bg-gray-100'
                >
                  <td>
                    <div className='flex items-center'>
                      <div
                        className='flex-auto px-6 py-4'
                        onClick={() => moveToDetailPage(product.id)}
                      >
                        {product.name}
                      </div>
                      <div className='pr-4'>
                        <button
                          type='button'
                          className='text-white bg-red-500 hover:bg-red-700 focus:ring-4 focus:ring-red-300 rounded-md px-4 py-2'
                          onClick={() => submitDeleteProduct(product.id)}
                        >
                          削除
                        </button>
                      </div>
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

export default ProductsTable
