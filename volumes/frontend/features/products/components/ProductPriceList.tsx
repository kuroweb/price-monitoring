'use client'

import { Fragment, useState } from 'react'

import Link from 'next/link'

import type { ProductList, ProductPriceList as ProductPrices } from '@/features/products/api/types'
import UpdateProductModal from '@/features/products/components/UpdateProductModal'
import { useUpdateProductModalState } from '@/features/products/hooks/useUpdateProductModalState'
import type { Category } from '@/lib/category'

import RelatedProductCard from './RelatedProductCard'

interface Props {
  productPrices: ProductPrices
  products: ProductList['products']
  categories: Category[]
}

const ProductPriceList = ({ productPrices, products, categories }: Props) => {
  const [_updateModal, setUpdateModal] = useUpdateProductModalState()
  const [product, setProduct] = useState<ProductList['products'][number] | undefined>(undefined)

  return (
    <>
      {productPrices.length === 0 && (
        <p>表示できる商品がありません。商品を追加するか、カテゴリを変更してください。</p>
      )}
      {productPrices.map((productPrice) => (
        <Fragment key={productPrice.id}>
          <div className='flex items-center justify-between gap-4'>
            <Link className='card-title' href={`/products/${productPrice.id}`}>
              {productPrice.name}
            </Link>
            <button
              className='btn'
              onClick={() => {
                setProduct(products.find((product) => product.id === productPrice.id))
                setUpdateModal(true)
              }}
            >
              計測設定
            </button>
          </div>
          <div className='grid auto-cols-[10rem] grid-flow-col gap-2 overflow-x-auto pt-4'>
            {productPrice.relatedProducts.length === 0 && (
              <p className='col-span-full'>関連商品の価格情報はまだありません。</p>
            )}
            {productPrice.relatedProducts.map((relatedProduct) => (
              <RelatedProductCard key={relatedProduct.externalId} relatedProduct={relatedProduct} />
            ))}
          </div>
          <div className='divider my-1' />
        </Fragment>
      ))}
      <UpdateProductModal
        key={`update-${product?.id ?? 'none'}`}
        productId={product?.id || 0}
        product={product}
        categories={categories}
      />
    </>
  )
}

export default ProductPriceList
