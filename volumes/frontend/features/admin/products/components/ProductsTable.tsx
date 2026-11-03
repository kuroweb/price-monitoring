'use client'

import { useRef, useState } from 'react'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { destroyProduct } from '@/lib/actions'
import type { Category, ProductList } from '@/lib/api'

import UpdateProductModal from '../common/components/update-product-modal/UpdateProductModal'
import { useUpdateProductModalState } from '../common/components/update-product-modal/hooks/useUpdateProductModalState'

import CreateProductModal from './create-product-modal/CreateProductModal'
import { useCreateProductModalState } from './create-product-modal/hooks/useCreateProductModalState'

interface Props {
  products: ProductList['products']
  categories: Category[]
}

const ProductsTable = ({ products, categories }: Props) => {
  const router = useRouter()
  const [_createModal, setCreateModal] = useCreateProductModalState()
  const [_updateModal, setUpdateModal] = useUpdateProductModalState()
  const [product, setProduct] = useState<ProductList['products'][number] | undefined>(undefined)

  const [search, setSearch] = useState('')
  const [category, setCategory] = useState('')
  const [status, setStatus] = useState('')
  const [deletingId, setDeletingId] = useState<number | null>(null)
  const deletingRef = useRef(false)
  const filteredProducts = products.filter((item) => {
    const enabled = [
      item.yahooAuctionCrawlSetting,
      item.mercariCrawlSetting,
      item.janparaCrawlSetting,
      item.iosysCrawlSetting,
      item.pcKoubouCrawlSetting,
      item.usedSofmapCrawlSetting,
    ].some((setting) => setting?.enabled)
    return (
      item.name.toLowerCase().includes(search.toLowerCase()) &&
      (!category || String(item.category?.id) === category) &&
      (!status || (status === 'enabled' ? enabled : !enabled))
    )
  })

  const submitDeleteProduct = async (item: Props['products'][number]) => {
    if (
      deletingRef.current ||
      !window.confirm(`管理コード「${item.name}」の計測対象を削除しますか？`)
    )
      return
    deletingRef.current = true
    setDeletingId(item.id)
    try {
      const res = await destroyProduct(item.id)
      if (res.status === 200) {
        toast.success('計測対象を削除しました')
        router.refresh()
      } else {
        toast.error('計測対象の削除に失敗しました')
      }
    } catch {
      toast.error('計測対象の削除に失敗しました')
    } finally {
      deletingRef.current = false
      setDeletingId(null)
    }
  }

  return (
    <>
      <div className='flex flex-wrap items-end gap-2'>
        <label className='min-w-40 flex-1'>
          <span className='label'>管理コード検索</span>
          <input
            className='input w-full'
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </label>
        <label>
          <span className='label'>カテゴリ</span>
          <select
            className='select w-full'
            value={category}
            onChange={(e) => setCategory(e.target.value)}
          >
            <option value=''>すべて</option>
            {categories.map((item) => (
              <option key={item.id} value={item.id}>
                {item.name}
              </option>
            ))}
          </select>
        </label>
        <label>
          <span className='label'>計測状態</span>
          <select
            className='select w-full'
            value={status}
            onChange={(e) => setStatus(e.target.value)}
          >
            <option value=''>すべて</option>
            <option value='enabled'>計測中</option>
            <option value='disabled'>停止中</option>
          </select>
        </label>
        <button
          type='button'
          className='btn btn-ghost'
          onClick={() => {
            setSearch('')
            setCategory('')
            setStatus('')
          }}
        >
          絞り込みをリセット
        </button>
      </div>
      <p role='status'>
        {filteredProducts.length}件 / 全{products.length}件
      </p>
      {products.length === 0 ? (
        <p>計測対象がありません。「計測対象を追加」から登録してください。</p>
      ) : filteredProducts.length === 0 ? (
        <p>条件に一致する計測対象がありません。</p>
      ) : null}
      <table className='table w-full table-fixed'>
        <thead>
          <tr>
            <th>管理コード</th>
            <th className='w-24 sm:w-36'></th>
          </tr>
        </thead>
        <tbody>
          {filteredProducts.map((product) => (
            <tr key={product.id} className=''>
              <td>
                <Link
                  className='btn btn-ghost no-animation h-auto min-h-10 w-full justify-start whitespace-normal wrap-anywhere py-2 text-left'
                  href={`/products/${product.id}`}
                >
                  {product.name}
                </Link>
              </td>
              <td>
                <div className='flex flex-col items-center gap-1 sm:flex-row'>
                  <button
                    type='button'
                    className='btn btn-primary btn-sm whitespace-nowrap px-1 text-xs sm:px-2 sm:text-sm'
                    onClick={() => {
                      setProduct(product)
                      setUpdateModal(true)
                    }}
                  >
                    計測設定
                  </button>
                  <div className='dropdown dropdown-left'>
                    <button
                      type='button'
                      aria-label={`${product.name}の操作`}
                      className='btn btn-square btn-md'
                    >
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
                    </button>
                    <ul className='menu dropdown-content z-1 w-20 space-y-2 rounded-box border border-base-300 bg-base-100 shadow-lg'>
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
                          disabled={deletingId !== null}
                          onClick={() => submitDeleteProduct(product)}
                        >
                          削除
                        </button>
                      </li>
                    </ul>
                  </div>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <CreateProductModal
        key={`create-${product?.id ?? 'none'}`}
        product={product}
        categories={categories}
      />
      <UpdateProductModal
        key={`update-${product?.id ?? 'none'}`}
        productId={product?.id || 0}
        product={product}
        categories={categories}
      />
    </>
  )
}

export default ProductsTable
