import Link from 'next/link'

import type { ProductsCategoriesCategoryPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import CategoryNavigation from '@/features/products/components/CategoryNavigation'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import { ProductsCategoriesCategoryPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async ({ params }: { params: { category: string } }) => {
  const { data } = await getClient().query<ProductsCategoriesCategoryPageDataQuery>({
    query: ProductsCategoriesCategoryPageDataDocument,
    variables: { name: decodeURIComponent(params.category) },
  })

  console.log(params.category)

  return (
    <Layout>
      <div className='grid grid-cols-1 space-y-4'>
        <div className='card bg-neutral'>
          <div className='card-body'>
            <CategoryNavigation
              parentCategoryName={data?.category?.parent?.name}
              currentCategoryName={data.category.name}
              childCategoryNames={data.category.children.map((category) => category.name)}
            />
          </div>
        </div>
        <div className='card bg-neutral'>
          <div className='card-body'>
            {data.category.products.map((product) => (
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
