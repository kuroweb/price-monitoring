'use client'

import { useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { useEditCrawlSettingModal } from '../hooks/useEditCrawlSettingModal'
import { deleteProduct } from '../server-actions/productQuery'

import EditCrawlSettingModal from './edit-crawl-setting-modal/EditCrawlSettingModal'

import { GetProductPageDataQuery } from '@/graphql/dist/client'

const ProductsTable = ({ data }: { data: GetProductPageDataQuery | null }) => {
  const router = useRouter()
  const [_, setModal] = useEditCrawlSettingModal()
  const [product, setProduct] = useState<GetProductPageDataQuery['products'][number] | undefined>(
    undefined,
  )
  const [productId, setProductId] = useState<string | undefined>(undefined)

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
      {data && (
        <>
          <table className='table select-none'>
            <thead>
              <tr>
                <th>管理コード</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {data.products.map((product) => (
                <tr key={product.id} className='cursor-pointer hover:bg-base-100'>
                  <td className='' onClick={() => moveToDetailPage(product.id)}>
                    {product.name}
                  </td>
                  <td className='w-1/12'>
                    <div className='dropdown dropdown-left'>
                      <div tabIndex={0} role='button' className='btn btn-square btn-md'>
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
                      </div>
                      <ul
                        tabIndex={0}
                        className='dropdown-content z-[1] menu space-y-2 shadow bg-base-200 rounded-box w-20'
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
          <EditCrawlSettingModal
            productId={productId}
            defaultValues={{
              name: product?.name || '',
              yahoo_auction_crawl_setting: {
                keyword: product?.yahooAuctionCrawlSetting?.keyword || '',
                category_id: product?.yahooAuctionCrawlSetting?.categoryId || null,
                min_price: product?.yahooAuctionCrawlSetting?.minPrice || 0,
                max_price: product?.yahooAuctionCrawlSetting?.maxPrice || 0,
                enabled: product?.yahooAuctionCrawlSetting?.enabled || false,
              },
            }}
          />
        </>
      )}
    </>
  )
}

export default ProductsTable
