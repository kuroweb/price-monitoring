import Link from 'next/link'

import type { GetCategoryDetailPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import { GetCategoryDetailPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async ({ params }: { params: { slug: string[] } }) => {
  const { data } = await getClient().query<GetCategoryDetailPageDataQuery>({
    query: GetCategoryDetailPageDataDocument,
    variables: { name: decodeURIComponent(params.slug[params.slug.length - 1]) },
  })

  console.log(params.slug.slice(0, -1).map(decodeURIComponent).join('/'))

  return (
    <Layout>
      <div className='grid grid-cols-1'>
        <div className='pb-4'>
          {data.category.parent && (
            <Link
              className=''
              href={`/categories/${params.slug.slice(0, -1).map(decodeURIComponent).join('/')}`}
            >
              {data.category.parent?.name}
              <span> / </span>
            </Link>
          )}
          <span>{data.category.name}</span>
          {data.category.children.map((child) => {
            return (
              <>
                <div>
                  <span>- </span>
                  <Link
                    className=''
                    href={`/categories/${[...params.slug, child.name].map(decodeURIComponent).join('/')}`}
                  >
                    {child.name}
                  </Link>
                </div>
              </>
            )
          })}
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
