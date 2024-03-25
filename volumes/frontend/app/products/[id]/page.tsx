import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import AnalysisChart from '@/features/products/components/AnalysisChart'
import MercariProductsTable from '@/features/products/components/MercariProductsTable'
import YahooAuctionProductsTable from '@/features/products/components/YahooAuctionProductsTable'
import DetailPageSidebarContent from '@/features/products/components/detail-page-sidebar-content/DetailPageSidebarContent'
import EditCrawlSettingModal from '@/features/products/components/edit-crawl-setting-modal/EditCrawlSettingModal'
import EditExcludeKeywordModal from '@/features/products/components/edit-exclude-keyword-modal/EditExcludeKeywordModal'
import { useEditCrawlSettingModalQuery } from '@/features/products/hooks/useEditCrawlSettingModalState'
import { useEditExcludeKeywordModalQuery } from '@/features/products/hooks/useEditExcludeKeywordModalState'
import {
  publishedStateCache,
  usePublishedStateQuery,
} from '@/features/products/hooks/usePublishedState'
import {
  GetProductDetailPageDataDocument,
  GetProductDetailPageDataQuery,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async ({
  params,
  searchParams,
}: {
  params: { [key: string]: string | undefined }
  searchParams: { [key: string]: string | undefined }
}) => {
  const { [usePublishedStateQuery]: published } = publishedStateCache.parse(searchParams)

  const { data } = await getClient().query<GetProductDetailPageDataQuery>({
    query: GetProductDetailPageDataDocument,
    variables: {
      id: params.id,
      published: published,
    },
  })

  return (
    <Layout sidebarChildren={<DetailPageSidebarContent />}>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>設定</h2>
            <div className='grid grid-cols-2 gap-4'>
              <Link
                className='btn'
                href={{
                  pathname: `/products/${params.id}`,
                  query: {
                    ...searchParams,
                    [useEditCrawlSettingModalQuery]: 'true',
                  },
                }}
              >
                計測設定
              </Link>
              <Link
                className='btn'
                href={{
                  pathname: `/products/${params.id}`,
                  query: {
                    ...searchParams,
                    [useEditExcludeKeywordModalQuery]: 'true',
                  },
                }}
              >
                除外キーワード
              </Link>
              <EditExcludeKeywordModal data={data} />
            </div>
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>相場グラフ</h2>
            <AnalysisChart
              yahooAuctionData={data.product.yahooAuctionDailyPurchaseSummaries}
              mercariData={data.product.mercariDailyPurchaseSummaries}
            />
          </div>
        </div>
        <div className='flex justify-end'>
          {published ? (
            <>
              <Link
                href={{
                  pathname: `/products/${params.id}`,
                  query: {
                    ...searchParams,
                    [usePublishedStateQuery]: false,
                  },
                }}
                className='btn btn-link'
              >
                落札一覧に切り替え
              </Link>
            </>
          ) : (
            <>
              <Link
                href={{
                  pathname: `/products/${params.id}`,
                  query: {
                    ...searchParams,
                    [usePublishedStateQuery]: true,
                  },
                }}
                className='btn btn-link'
              >
                出品一覧に切り替え
              </Link>
            </>
          )}
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>メルカリ</h2>
            <MercariProductsTable data={data} />
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>ヤフオク</h2>
            <YahooAuctionProductsTable data={data} />
          </div>
        </div>
      </div>
      <EditCrawlSettingModal
        productId={params.id}
        defaultValues={{
          name: data.product.name,
          yahoo_auction_crawl_setting: {
            keyword: data.product.yahooAuctionCrawlSetting?.keyword,
            category_id: data.product.yahooAuctionCrawlSetting?.categoryId,
            min_price: data.product.yahooAuctionCrawlSetting?.minPrice,
            max_price: data.product.yahooAuctionCrawlSetting?.maxPrice,
            enabled: data.product.yahooAuctionCrawlSetting?.enabled,
          },
          mercari_crawl_setting: {
            keyword: data.product.mercariCrawlSetting?.keyword,
            min_price: data.product.mercariCrawlSetting?.minPrice,
            max_price: data.product.mercariCrawlSetting?.maxPrice,
            enabled: data.product.mercariCrawlSetting?.enabled,
          },
        }}
      />
    </Layout>
  )
}

export default Page
