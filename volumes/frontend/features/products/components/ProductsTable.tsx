'use client'

import { ApolloError } from '@apollo/client'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { deleteProduct } from '../server-actions/product-query'

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
    router.refresh()
  }

  return (
    <>
      {error?.message && <div>{error.message}</div>}
      <div className='relative overflow-x-auto shadow-md rounded-lg select-none'>
        <table className='w-full text-left'>
          <thead className='uppercase'>
            <tr>
              <th className='p-4'>管理コード</th>
              <th className='p-4 flex justify-center'>
                <svg
                  xmlns='http://www.w3.org/2000/svg'
                  fill='none'
                  viewBox='0 0 24 24'
                  className='inline-block w-5 h-5 stroke-current'
                >
                  <path
                    strokeLinecap='round'
                    strokeLinejoin='round'
                    strokeWidth='2'
                    d='M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z'
                  ></path>
                </svg>
              </th>
            </tr>
          </thead>
          <tbody>
            {data.products.map((product) => (
              <tr key={product.id} className='border-b cursor-pointer hover:bg-base-100'>
                <td className='px-4 w-4/5' onClick={() => moveToDetailPage(product.id)}>
                  {product.name}
                </td>
                <td className='p-2 w-1/5'>
                  <div className='flex justify-center'>
                    <button
                      onClick={() => submitDeleteProduct(product.id)}
                      className='btn btn-error'
                    >
                      削除
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  )
}

export default ProductsTable
