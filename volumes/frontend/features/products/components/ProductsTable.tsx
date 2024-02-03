'use client'

import { useEffect, useState } from 'react'

import { useRouter, usePathname, useSearchParams } from 'next/navigation'
import { toast } from 'react-toastify'

import { deleteProduct, getProducts } from '../server-actions/product-query'

import { GetProductsQuery } from '@/graphql/dist/client'

const ProductsTable = () => {
  const [products, setProducts] = useState<GetProductsQuery['products']>([])
  const [errorMessage, setErrorMessage] = useState<string | undefined>(undefined)

  const fetchProducts = async () => {
    const result = await getProducts()
    setProducts(result.data.products)
    setErrorMessage(result.error?.message)
  }

  const router = useRouter()
  const pathname = usePathname()
  const searchParams = useSearchParams()

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
    fetchProducts()
  }

  // MEMO: そもそもuseEffect内でAPIを叩いて初期化するのがよくない？
  useEffect(() => {
    fetchProducts()
  }, [pathname, searchParams])

  return (
    <>
      {errorMessage && <div>{errorMessage}</div>}
      <div className='relative overflow-x-auto shadow-md rounded-lg'>
        <table className='w-full text-sm text-left text-gray-500'>
          <thead className='text-xs text-gray-700 uppercase bg-gray-50'>
            <tr>
              <th className='px-6 py-3'>name</th>
            </tr>
          </thead>
          <tbody>
            {products.map((product) => (
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
    </>
  )
}

export default ProductsTable
