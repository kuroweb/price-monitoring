import Link from 'next/link'
import { notFound } from 'next/navigation'

import Layout from '@/components/layouts/Layout'
import AnalysisChart from '@/features/products/components/AnalysisChart'
import Pagination from '@/features/products/components/Pagination'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import SearchForm from '@/features/products/components/SearchForm'
import UpdateProductModal from '@/features/products/components/UpdateProductModal'
import { usePageStateQuery, pageStateCache } from '@/features/products/hooks/usePageState'
import { usePerStateQuery, perStateCache } from '@/features/products/hooks/usePerState'
import {
  usePlatformStateQuery,
  platformStateCache,
} from '@/features/products/hooks/usePlatformState'
import {
  useStatusStateQuery,
  statusStateCache,
} from '@/features/products/hooks/useStatusState'
import { useUpdateProductModalQuery } from '@/features/products/hooks/useUpdateProductModalState'
import { makePlatformMask } from '@/features/products/lib/makePlatformMask'
import { getCategories, getProduct, getProductPrice } from '@/lib/actions'

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

  const productId = Number(resolvedParams.id)
  if (!resolvedParams.id || !/^\d+$/.test(resolvedParams.id) || !Number.isSafeInteger(productId) || productId < 1) notFound()
  const [productPriceDetailResponse, productResponse, categoryResponse] = await Promise.all([
    getProductPrice(productId, {
      platformMask: makePlatformMask(platform, status),
      sort: status == 'published' ? 'price' : 'bought_date',
      order: status == 'published' ? 'asc' : 'desc',
      page,
      per,
    }),
    getProduct(productId),
    getCategories({ rootOnly: false }),
  ])
  if (productResponse.status === 404) notFound()
  if (productResponse.status !== 200 || productPriceDetailResponse.status !== 200) {
    throw new Error('商品情報の取得に失敗しました')
  }
  const productPriceDetail = productPriceDetailResponse.data

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-base-300'>
          <div className='card-body flex-row flex-wrap items-center justify-between gap-4'>
            <h1 className='card-title text-xl'>{productPriceDetail?.name}</h1>
            <Link
              className='btn'
              href={{
                query: {
                  ...resolvedSearchParams,
                  [useUpdateProductModalQuery]: 'true',
                },
              }}
            >
              計測設定
            </Link>
          </div>
        </div>
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
      <UpdateProductModal
        productId={productId}
        product={productResponse?.data || undefined}
        categories={categoryResponse?.data?.categories || []}
      />
    </Layout>
  )
}

export default Page
