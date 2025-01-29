import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import CategoryNavigation from '@/features/products/components/CategoryNavigation'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import {
  categoryIdStateCache,
  useCategoryIdStateQuery,
} from '@/features/products/hooks/useCategoryIdState'
import { getCategoriesStructured, getCategoryStructuredSubtree } from '@/server-actions/api'
import { getProductPrices } from '@/server-actions/api/productPrices'

const Page = async ({ searchParams }: { searchParams: { [key: string]: string | undefined } }) => {
  const { [useCategoryIdStateQuery]: categoryId } = categoryIdStateCache.parse(searchParams)

  let currentCategory, parentCategory, childCategories
  if (categoryId === -1) {
    const response = await getCategoriesStructured({ rootOnly: true })
    currentCategory = undefined
    parentCategory = undefined
    childCategories = response.data?.categories || []
  } else {
    const response = await getCategoryStructuredSubtree(categoryId, { displayDepthLimit: 1 })
    currentCategory = response.data || undefined
    parentCategory = response.data?.parent || undefined
    childCategories = response.data?.children || []
  }

  const productPricesResponse = await getProductPrices({
    categoryId: categoryId === -1 ? null : categoryId,
    platformMask:
      'yahoo_auction.buyable,yahoo_fleamarket.published,mercari.published,janpara.all,iosys.all,pc_koubou.all',
    sort: 'price',
    order: 'asc',
    priceDisplayLimit: 10,
  })
  const productPrices = productPricesResponse.data || []

  return (
    <Layout>
      <div className='grid grid-cols-1 space-y-4'>
        <div className='card bg-neutral'>
          <div className='card-body'>
            <CategoryNavigation
              currentCategory={currentCategory}
              parentCategory={parentCategory}
              childCategories={childCategories}
            />
          </div>
        </div>
        <div className='card bg-neutral'>
          <div className='card-body'>
            {productPrices.map((product) => (
              <>
                <Link className='card-title' href={`/products/${product.id}`}>
                  {product.name}
                </Link>
                <div className='grid auto-cols-[10rem] grid-flow-col gap-2 overflow-x-auto pt-4'>
                  {product.relatedProducts.map((relatedProduct) => (
                    <RelatedProductCard
                      key={relatedProduct.externalId}
                      relatedProduct={relatedProduct}
                    />
                  ))}
                </div>
                <div className='divider my-1' />
              </>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
