import Link from 'next/link'

import type { GetRecommendsPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import { GetRecommendsPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async () => {
  const { data } = await getClient().query<GetRecommendsPageDataQuery>({
    query: GetRecommendsPageDataDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        {data.products.map((product) => {
          return (
            <>
              <div className='card w-full bg-neutral'>
                <div className='card-body'>
                  <Link className='card-title' href={`/products/${product.id}`}>
                    {product.name}
                  </Link>
                  <div className='grid grid-cols-2 gap-4 pt-4 md:grid-cols-3 lg:grid-cols-4'>
                    {product.relatedProducts.map((relatedProduct) => (
                      <RelatedProductCard
                        key={relatedProduct.externalId}
                        relatedProduct={relatedProduct}
                      />
                    ))}
                  </div>
                </div>
              </div>
            </>
          )
        })}
      </div>
    </Layout>
  )
}

export default Page
