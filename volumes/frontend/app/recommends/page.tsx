import Link from 'next/link'

import type { GetRecommendsPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import RelatedProductCard from '@/features/recommends/components/RelatedProductCard'
import { GetRecommendsPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async () => {
  const { data } = await getClient().query<GetRecommendsPageDataQuery>({
    query: GetRecommendsPageDataDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1'>
        <div className='card bg-neutral'>
          <div className='card-body'>
            {data.products.map((product) => (
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
