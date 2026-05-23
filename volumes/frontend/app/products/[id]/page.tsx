import Layout from '@/components/layouts/Layout'
import AnalysisChart from '@/features/products/[id]/components/AnalysisChart'
import Pagination from '@/features/products/[id]/components/Pagination'
import SearchForm from '@/features/products/[id]/components/SearchForm'
import { usePageStateQuery, pageStateCache } from '@/features/products/[id]/hooks/usePageState'
import { usePerStateQuery, perStateCache } from '@/features/products/[id]/hooks/usePerState'
import {
  usePlatformStateQuery,
  platformStateCache,
} from '@/features/products/[id]/hooks/usePlatformState'
import {
  useStatusStateQuery,
  statusStateCache,
} from '@/features/products/[id]/hooks/useStatusState'
import { makePlatformMask } from '@/features/products/[id]/lib/makePlatformMask'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import { getProductPrice } from '@/lib/actions'

const Page = async ({
  params,
  searchParams,
}: {
  params: Promise<{ [key: string]: string | undefined }>
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>
}) => {
  const resolvedParams = await params
  const resolvedSearchParams = await searchParams
  const { [usePlatformStateQuery]: platform } = platformStateCache.parse(resolvedSearchParams)
  const { [useStatusStateQuery]: status } = statusStateCache.parse(resolvedSearchParams)
  const { [usePageStateQuery]: page } = pageStateCache.parse(resolvedSearchParams)
  const { [usePerStateQuery]: per } = perStateCache.parse(resolvedSearchParams)

  const productPriceDetailResponse = await getProductPrice(Number(resolvedParams.id), {
    platformMask: makePlatformMask(platform, status),
    sort: status == 'published' ? 'price' : 'bought_date',
    order: status == 'published' ? 'asc' : 'desc',
    page,
    per,
  })
  const productPriceDetail = productPriceDetailResponse.data

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-base-300'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>価格推移</h2>
            <AnalysisChart
              yahooAuctionData={productPriceDetail?.yahooAuctionDailyPurchaseSummaries || []}
              yahooFleamarketData={productPriceDetail?.yahooFleamarketDailyPurchaseSummaries || []}
              mercariData={productPriceDetail?.mercariDailyPurchaseSummaries || []}
            />
          </div>
        </div>
        <div className='card w-full bg-base-300'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>商品一覧</h2>
            <SearchForm />
            <div className='grid grid-cols-2 gap-4 pt-4 md:grid-cols-3 lg:grid-cols-5 xl:grid-cols-6'>
              {productPriceDetail?.relatedProducts.map((relatedProduct) => (
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
