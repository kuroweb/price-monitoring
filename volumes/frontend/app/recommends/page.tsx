import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import RelatedProductsTable from '@/features/products/components/RelatedProductsTable'
import { GetRecommendsPageDataDocument, GetRecommendsPageDataQuery } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async ({ searchParams }: { searchParams: { [key: string]: string | undefined } }) => {
  const { data } = await getClient().query<GetRecommendsPageDataQuery>({
    query: GetRecommendsPageDataDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        {/* TODO: コンポーネントを追加する */}
        {data.products.map((product) => {
          return (
            <>
              <div className='card w-full bg-neutral'>
                <div className='card-body'>
                  <Link className='card-title' href={`/products/${product.id}`}>
                    {product.name}
                  </Link>
                  <RelatedProductsTable relatedProducts={product.relatedProducts} />
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
