'use client'

import { useState } from 'react'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { useCreateProductModalState } from '../hooks/useCreateProductModalState'
import { useUpdateProductModalState } from '../hooks/useUpdateProductModalState'

import CreateProductModal from './create-product-modal'
import UpdateProductModal from './update-product-modal'

import type { Category, ProductList } from '@/api'

import { destroyProduct } from '@/server-actions/api'

interface Props {
  products: ProductList['products']
  categories: Category[]
}

const ProductsTable = ({ products, categories }: Props) => {
  const router = useRouter()
  const [_createModal, setCreateModal] = useCreateProductModalState()
  const [_updateModal, setUpdateModal] = useUpdateProductModalState()
  const [product, setProduct] = useState<ProductList['products'][number] | undefined>(undefined)

  const submitDeleteProduct = async (productId: number) => {
    const res = await destroyProduct(productId)

    if (res.status === 200) {
      toast.success('success')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  return (
    <>
      <table className='table'>
        <thead>
          <tr>
            <th>管理コード</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {products.map((product) => (
            <tr key={product.id} className=''>
              <td>
                <Link
                  className='btn btn-ghost no-animation w-full justify-start'
                  href={`/admin/products/${product.id}`}
                >
                  {product.name}
                </Link>
              </td>
              <td className='w-1/12'>
                <div className='dropdown dropdown-left'>
                  <div tabIndex={0} role='button' className='btn btn-square btn-md'>
                    <svg
                      xmlns='http://www.w3.org/2000/svg'
                      fill='none'
                      viewBox='0 0 24 24'
                      className='inline-block size-5 stroke-current'
                    >
                      <path
                        strokeLinecap='round'
                        strokeLinejoin='round'
                        strokeWidth='2'
                        d='M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z'
                      ></path>
                    </svg>
                  </div>
                  <ul
                    tabIndex={0}
                    className='menu dropdown-content z-[1] w-20 space-y-2 rounded-box bg-base-200 shadow'
                  >
                    <li>
                      <button
                        className='btn btn-primary'
                        onClick={() => {
                          setProduct(product)
                          setUpdateModal(true)
                        }}
                      >
                        編集
                      </button>
                    </li>
                    <li>
                      <button
                        className='btn btn-success'
                        onClick={() => {
                          setProduct(product)
                          setCreateModal(true)
                        }}
                      >
                        複製
                      </button>
                    </li>
                    <li>
                      <button
                        className='btn btn-error'
                        onClick={() => submitDeleteProduct(product.id)}
                      >
                        削除
                      </button>
                    </li>
                  </ul>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <CreateProductModal key={product?.id} productDetail={product} categories={categories} />
      <UpdateProductModal
        key={product?.id}
        productId={product?.id || 0}
        productDetail={product}
        categories={categories}
      />
    </>
  )
}

export default ProductsTable
