import type { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import AnalysisChart from '@/features/products/components/AnalysisChart'
import Menu from '@/features/products/components/Menu'
import Pagination from '@/features/products/components/Pagination'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import SearchForm from '@/features/products/components/SearchForm'
import { pageStateCache, usePageStateQuery } from '@/features/products/hooks/usePageState'
import { usePerStateQuery, perStateCache } from '@/features/products/hooks/usePerState'
import {
  platformStateCache,
  usePlatformStateQuery,
} from '@/features/products/hooks/usePlatformState'
import { statusStateCache, useStatusStateQuery } from '@/features/products/hooks/useStatusState'
import { makePlatformMask } from '@/features/products/lib/makePlatformMask'
import { GetProductDetailPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async ({
  params,
  searchParams,
}: {
  params: { [key: string]: string | undefined }
  searchParams: { [key: string]: string | undefined }
}) => {
  const { [usePlatformStateQuery]: platform } = platformStateCache.parse(searchParams)
  const { [useStatusStateQuery]: status } = statusStateCache.parse(searchParams)
  const { [usePageStateQuery]: page } = pageStateCache.parse(searchParams)
  const { [usePerStateQuery]: per } = perStateCache.parse(searchParams)

  const { data } = await getClient().query<GetProductDetailPageDataQuery>({
    query: GetProductDetailPageDataDocument,
    variables: {
      id: params.id,
      platformMask: makePlatformMask(platform, status),
      page,
      per,
      sort: status == 'published' ? 'price' : 'bought_date',
      order: status == 'published' ? 'asc' : 'desc',
    },
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <Menu />
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>価格推移</h2>
            <AnalysisChart
              yahooAuctionData={data.product.yahooAuctionDailyPurchaseSummaries}
              yahooFleamarketData={data.product.yahooFleamarketDailyPurchaseSummaries}
              mercariData={data.product.mercariDailyPurchaseSummaries}
            />
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>商品一覧</h2>
            <SearchForm />
            <div className='grid grid-cols-2 gap-4 pt-4 md:grid-cols-3 lg:grid-cols-4'>
              {data.product.relatedProducts.map((relatedProduct) => (
                <RelatedProductCard
                  key={relatedProduct.externalId}
                  relatedProduct={relatedProduct}
                />
              ))}
            </div>
            <Pagination />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
