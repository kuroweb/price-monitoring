'use client'

import { useState } from 'react'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { useUpdateProductModalState } from '../hooks/useUpdateProductModalState'
import { deleteProduct } from '../server-actions/graphql/productQuery'

import UpdateProductModal from './update-product-modal/UpdateProductModal'

import type { GetProductPageDataQuery } from '@/graphql/dist/client'

const ProductsTable = ({ data }: { data: GetProductPageDataQuery | undefined }) => {
  const router = useRouter()
  const [_, setModal] = useUpdateProductModalState()
  const [product, setProduct] = useState<GetProductPageDataQuery['products'][number] | undefined>(
    undefined,
  )

  const submitDeleteProduct = async (productId: string) => {
    const result = await deleteProduct({
      id: productId,
    })

    if (result.data?.deleteProduct.ok) {
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
          {data?.products.map((product) => (
            <tr key={product.id} className=''>
              <td>
                <Link
                  className='btn btn-ghost no-animation w-full justify-start'
                  href={`/products/${product.id}`}
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
                          setModal(true)
                        }}
                      >
                        編集
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
      <UpdateProductModal
        defaultValues={
          product && {
            id: product?.id,
            name: product?.name,
            yahooAuctionCrawlSetting: {
              keyword: product?.yahooAuctionCrawlSetting?.keyword,
              categoryId: product?.yahooAuctionCrawlSetting?.categoryId,
              minPrice: product?.yahooAuctionCrawlSetting?.minPrice,
              maxPrice: product?.yahooAuctionCrawlSetting?.maxPrice,
              enabled: product?.yahooAuctionCrawlSetting?.enabled,
            },
            mercariCrawlSetting: {
              keyword: product?.mercariCrawlSetting?.keyword,
              categoryId: product?.mercariCrawlSetting?.categoryId,
              minPrice: product?.mercariCrawlSetting?.minPrice,
              maxPrice: product?.mercariCrawlSetting?.maxPrice,
              enabled: product?.mercariCrawlSetting?.enabled,
            },
            janparaCrawlSetting: {
              keyword: product?.janparaCrawlSetting?.keyword,
              minPrice: product?.janparaCrawlSetting?.minPrice,
              maxPrice: product?.janparaCrawlSetting?.maxPrice,
              enabled: product?.janparaCrawlSetting?.enabled,
            },
            iosysCrawlSetting: {
              keyword: product?.iosysCrawlSetting?.keyword,
              minPrice: product?.iosysCrawlSetting?.minPrice,
              maxPrice: product?.iosysCrawlSetting?.maxPrice,
              enabled: product?.iosysCrawlSetting?.enabled,
            },
            pcKoubouCrawlSetting: {
              keyword: product?.pcKoubouCrawlSetting?.keyword,
              minPrice: product?.pcKoubouCrawlSetting?.minPrice,
              maxPrice: product?.pcKoubouCrawlSetting?.maxPrice,
              enabled: product?.pcKoubouCrawlSetting?.enabled,
            },
            usedSofmapCrawlSetting: {
              keyword: product?.usedSofmapCrawlSetting?.keyword,
              minPrice: product?.usedSofmapCrawlSetting?.minPrice,
              maxPrice: product?.usedSofmapCrawlSetting?.maxPrice,
              enabled: product?.usedSofmapCrawlSetting?.enabled,
            },
          }
        }
      />
    </>
  )
}

export default ProductsTable
