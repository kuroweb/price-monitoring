import Link from 'next/link'

import type { GetRecommendsPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import { GetRecommendsPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async () => {
  const { data } = await getClient().query<GetRecommendsPageDataQuery>({
    query: GetRecommendsPageDataDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        {data.products.map((product) => (
          <>
            <div className='card w-full bg-neutral'>
              <div className='card-body'>
                <Link className='card-title' href={`/products/${product.id}`}>
                  {product.name}
                </Link>
                <div className='grid auto-cols-[10rem] grid-flow-col gap-4 overflow-x-auto pt-4'>
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
        ))}
      </div>
    </Layout>
  )
}

export default Page
