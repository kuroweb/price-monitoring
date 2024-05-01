import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import AnalysisChart from '@/features/products/components/AnalysisChart'
import Pagination from '@/features/products/components/Pagination'
import RelatedProductsTable from '@/features/products/components/RelatedProductsTable'
import SearchForm from '@/features/products/components/SearchForm'
import EditCrawlSettingModal from '@/features/products/components/edit-crawl-setting-modal/EditCrawlSettingModal'
import EditExcludeKeywordModal from '@/features/products/components/edit-exclude-keyword-modal/EditExcludeKeywordModal'
import EditRequiredKeywordModal from '@/features/products/components/edit-required-keyword-modal/EditRequiredKeywordModal'
import { useEditCrawlSettingModalQuery } from '@/features/products/hooks/useEditCrawlSettingModalState'
import { useEditExcludeKeywordModalQuery } from '@/features/products/hooks/useEditExcludeKeywordModalState'
import { useEditRequiredKeywordModalQuery } from '@/features/products/hooks/useEditRequiredKeywordModalState'
import { pageStateCache, usePageStateQuery } from '@/features/products/hooks/usePageState'
import { usePerStateQuery, perStateCache } from '@/features/products/hooks/usePerState'
import {
  platformMaskStateCache,
  usePlatformMaskStateQuery,
} from '@/features/products/hooks/usePlatformMaskState'
import {
  publishedStateCache,
  usePublishedStateQuery,
} from '@/features/products/hooks/usePublishedState'
import {
  useYahooAuctionBuyableStateQuery,
  yahooAuctionBuyableStateCache,
} from '@/features/products/hooks/useYahooAuctionBuyableState'
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
  const { [usePlatformMaskStateQuery]: platformMask } = platformMaskStateCache.parse(searchParams)
  const { [usePublishedStateQuery]: published } = publishedStateCache.parse(searchParams)
  const { [useYahooAuctionBuyableStateQuery]: yahooAuctionBuyable } =
    yahooAuctionBuyableStateCache.parse(searchParams)
  const { [usePageStateQuery]: page } = pageStateCache.parse(searchParams)
  const { [usePerStateQuery]: per } = perStateCache.parse(searchParams)

  const { data } = await getClient().query<GetProductDetailPageDataQuery>({
    query: GetProductDetailPageDataDocument,
    variables: {
      id: params.id,
      platformMask: platformMask,
      published: published,
      yahooAuctionBuyable: yahooAuctionBuyable,
      page: page,
      per: per,
      sort: published ? 'updated_at' : 'bought_date',
      order: 'desc',
    },
  })

  return (
    <Layout>
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
              <Link
                className='btn'
                href={{
                  pathname: `/products/${params.id}`,
                  query: {
                    ...searchParams,
                    [useEditRequiredKeywordModalQuery]: 'true',
                  },
                }}
              >
                必須キーワード
              </Link>
            </div>
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>相場グラフ</h2>
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
            <RelatedProductsTable relatedProducts={data.product.relatedProducts} />
            <Pagination />
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
            category_id: data.product.mercariCrawlSetting?.categoryId,
            min_price: data.product.mercariCrawlSetting?.minPrice,
            max_price: data.product.mercariCrawlSetting?.maxPrice,
            enabled: data.product.mercariCrawlSetting?.enabled,
          },
          janpara_crawl_setting: {
            keyword: data.product.janparaCrawlSetting?.keyword,
            min_price: data.product.janparaCrawlSetting?.minPrice,
            max_price: data.product.janparaCrawlSetting?.maxPrice,
            enabled: data.product.janparaCrawlSetting?.enabled,
          },
        }}
      />
      <EditExcludeKeywordModal data={data} />
      <EditRequiredKeywordModal data={data} />
    </Layout>
  )
}

export default Page
