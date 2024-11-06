'use client'

import { useState } from 'react'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { useCreateProductModalState } from '../hooks/useCreateProductModalState'
import { useUpdateProductModalState } from '../hooks/useUpdateProductModalState'

import CreateProductModal from './create-product-modal/CreateProductModal'
import UpdateProductModal from './update-product-modal/UpdateProductModal'

import type { Product, Category } from '@/api'

import { destroyProduct } from '@/server-actions/api'

interface Props {
  products: Product[]
  categories: Category[]
}

const ProductsTable = ({ products, categories }: Props) => {
  const router = useRouter()
  const [_createModal, setCreateModal] = useCreateProductModalState()
  const [_updateModal, setUpdateModal] = useUpdateProductModalState()
  const [product, setProduct] = useState<Product | undefined>(undefined)

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
      <CreateProductModal
        defaultValues={{
          name: product?.name || '',
          categoryId: product?.category?.id || categories[0].id,
          yahooAuctionCrawlSetting: {
            keyword: product?.yahooAuctionCrawlSetting?.keyword || '',
            categoryId: product?.yahooAuctionCrawlSetting?.categoryId || null,
            minPrice: product?.yahooAuctionCrawlSetting?.minPrice || 0,
            maxPrice: product?.yahooAuctionCrawlSetting?.maxPrice || 0,
            enabled: product?.yahooAuctionCrawlSetting?.enabled || true,
          },
          mercariCrawlSetting: {
            keyword: product?.mercariCrawlSetting?.keyword || '',
            categoryId: product?.mercariCrawlSetting?.categoryId || null,
            minPrice: product?.mercariCrawlSetting?.minPrice || 0,
            maxPrice: product?.mercariCrawlSetting?.maxPrice || 0,
            enabled: product?.mercariCrawlSetting?.enabled || true,
          },
          janparaCrawlSetting: {
            keyword: product?.janparaCrawlSetting?.keyword || '',
            minPrice: product?.janparaCrawlSetting?.minPrice || 0,
            maxPrice: product?.janparaCrawlSetting?.maxPrice || 0,
            enabled: product?.janparaCrawlSetting?.enabled || true,
          },
          iosysCrawlSetting: {
            keyword: product?.iosysCrawlSetting?.keyword || '',
            minPrice: product?.iosysCrawlSetting?.minPrice || 0,
            maxPrice: product?.iosysCrawlSetting?.maxPrice || 0,
            enabled: product?.iosysCrawlSetting?.enabled || true,
          },
          pcKoubouCrawlSetting: {
            keyword: product?.pcKoubouCrawlSetting?.keyword || '',
            minPrice: product?.pcKoubouCrawlSetting?.minPrice || 0,
            maxPrice: product?.pcKoubouCrawlSetting?.maxPrice || 0,
            enabled: product?.pcKoubouCrawlSetting?.enabled || true,
          },
          usedSofmapCrawlSetting: {
            keyword: product?.usedSofmapCrawlSetting?.keyword || '',
            minPrice: product?.usedSofmapCrawlSetting?.minPrice || 0,
            maxPrice: product?.usedSofmapCrawlSetting?.maxPrice || 0,
            enabled: product?.usedSofmapCrawlSetting?.enabled || true,
          },
        }}
        categories={categories}
      />
      <UpdateProductModal
        productId={product?.id || 0}
        defaultValues={{
          name: product?.name || '',
          categoryId: product?.category?.id || categories[0].id,
          yahooAuctionCrawlSetting: {
            keyword: product?.yahooAuctionCrawlSetting?.keyword || '',
            categoryId: product?.yahooAuctionCrawlSetting?.categoryId || null,
            minPrice: product?.yahooAuctionCrawlSetting?.minPrice || 0,
            maxPrice: product?.yahooAuctionCrawlSetting?.maxPrice || 0,
            enabled: product?.yahooAuctionCrawlSetting?.enabled || true,
          },
          mercariCrawlSetting: {
            keyword: product?.mercariCrawlSetting?.keyword || '',
            categoryId: product?.mercariCrawlSetting?.categoryId || null,
            minPrice: product?.mercariCrawlSetting?.minPrice || 0,
            maxPrice: product?.mercariCrawlSetting?.maxPrice || 0,
            enabled: product?.mercariCrawlSetting?.enabled || true,
          },
          janparaCrawlSetting: {
            keyword: product?.janparaCrawlSetting?.keyword || '',
            minPrice: product?.janparaCrawlSetting?.minPrice || 0,
            maxPrice: product?.janparaCrawlSetting?.maxPrice || 0,
            enabled: product?.janparaCrawlSetting?.enabled || true,
          },
          iosysCrawlSetting: {
            keyword: product?.iosysCrawlSetting?.keyword || '',
            minPrice: product?.iosysCrawlSetting?.minPrice || 0,
            maxPrice: product?.iosysCrawlSetting?.maxPrice || 0,
            enabled: product?.iosysCrawlSetting?.enabled || true,
          },
          pcKoubouCrawlSetting: {
            keyword: product?.pcKoubouCrawlSetting?.keyword || '',
            minPrice: product?.pcKoubouCrawlSetting?.minPrice || 0,
            maxPrice: product?.pcKoubouCrawlSetting?.maxPrice || 0,
            enabled: product?.pcKoubouCrawlSetting?.enabled || true,
          },
          usedSofmapCrawlSetting: {
            keyword: product?.usedSofmapCrawlSetting?.keyword || '',
            minPrice: product?.usedSofmapCrawlSetting?.minPrice || 0,
            maxPrice: product?.usedSofmapCrawlSetting?.maxPrice || 0,
            enabled: product?.usedSofmapCrawlSetting?.enabled || true,
          },
        }}
        categories={categories}
      />
    </>
  )
}

export default ProductsTable
