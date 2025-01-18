import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import CategoryNavigation from '@/features/products/components/CategoryNavigation'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import { getCategories } from '@/server-actions/api'
import { getProductPrices } from '@/server-actions/api/productPrices'

const Page = async () => {
  const categoriesResponse = await getCategories()
  const categories = categoriesResponse.data?.categories || []

  const productPricesResponse = await getProductPrices({
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
            <CategoryNavigation childCategoryNames={categories.map((category) => category.name)} />
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
