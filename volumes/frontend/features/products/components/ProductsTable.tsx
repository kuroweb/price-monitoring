'use client'

import { useState } from 'react'

import Link from 'next/link'
import { usePathname, useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { useUpdateProductModalState } from '../hooks/useUpdateProductModalState'
import { deleteProduct } from '../server-actions/productQuery'

import UpdateProductModal from './update-product-modal/UpdateProductModal'

import type { GetProductPageDataQuery } from '@/graphql/dist/client'

const ProductsTable = ({ data }: { data: GetProductPageDataQuery | undefined }) => {
  const pathname = usePathname()
  const router = useRouter()
  const [_, setModal] = useUpdateProductModalState()
  const [product, setProduct] = useState<GetProductPageDataQuery['products'][number] | undefined>(
    undefined,
  )
  const [productId, setProductId] = useState<string | undefined>(undefined)

  const submitDeleteProduct = async (productId: string) => {
    const result = await deleteProduct(productId, pathname)

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
                          setProductId(product.id)
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
        productId={productId}
        defaultValues={
          product && {
            name: product?.name,
            yahoo_auction_crawl_setting: {
              keyword: product?.yahooAuctionCrawlSetting?.keyword,
              category_id: product?.yahooAuctionCrawlSetting?.categoryId,
              min_price: product?.yahooAuctionCrawlSetting?.minPrice,
              max_price: product?.yahooAuctionCrawlSetting?.maxPrice,
              enabled: product?.yahooAuctionCrawlSetting?.enabled,
            },
            mercari_crawl_setting: {
              keyword: product?.mercariCrawlSetting?.keyword,
              category_id: product?.mercariCrawlSetting?.categoryId,
              min_price: product?.mercariCrawlSetting?.minPrice,
              max_price: product?.mercariCrawlSetting?.maxPrice,
              enabled: product?.mercariCrawlSetting?.enabled,
            },
            janpara_crawl_setting: {
              keyword: product?.janparaCrawlSetting?.keyword,
              min_price: product?.janparaCrawlSetting?.minPrice,
              max_price: product?.janparaCrawlSetting?.maxPrice,
              enabled: product?.janparaCrawlSetting?.enabled,
            },
            iosys_crawl_setting: {
              keyword: product?.iosysCrawlSetting?.keyword,
              min_price: product?.iosysCrawlSetting?.minPrice,
              max_price: product?.iosysCrawlSetting?.maxPrice,
              enabled: product?.iosysCrawlSetting?.enabled,
            },
            pc_koubou_crawl_setting: {
              keyword: product?.pcKoubouCrawlSetting?.keyword,
              min_price: product?.pcKoubouCrawlSetting?.minPrice,
              max_price: product?.pcKoubouCrawlSetting?.maxPrice,
              enabled: product?.pcKoubouCrawlSetting?.enabled,
            },
          }
        }
      />
    </>
  )
}

export default ProductsTable
