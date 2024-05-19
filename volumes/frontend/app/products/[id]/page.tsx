import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import AnalysisChart from '@/features/products/components/AnalysisChart'
import Pagination from '@/features/products/components/Pagination'
import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import SearchForm from '@/features/products/components/SearchForm'
import BulkEditExcludeKeywordModal from '@/features/products/components/bulk-edit-exclude-keyword-modal/BulkEditExcludeKeywordModal'
import BulkEditRequiredKeywordModal from '@/features/products/components/bulk-edit-required-keyword-modal/BulkEditRequiredKeywordModal'
import EditCrawlSettingModal from '@/features/products/components/edit-crawl-setting-modal/EditCrawlSettingModal'
import EditExcludeKeywordModal from '@/features/products/components/edit-exclude-keyword-modal/EditExcludeKeywordModal'
import EditExcludeProductModal from '@/features/products/components/edit-exclude-product-modal/EditExcludeProductModal'
import EditRequiredKeywordModal from '@/features/products/components/edit-required-keyword-modal/EditRequiredKeywordModal'
import { useBulkEditExcludeKeywordModalQuery } from '@/features/products/hooks/useBulkEditExcludeKeywordModalState'
import { useBulkEditRequiredKeywordModalQuery } from '@/features/products/hooks/useBulkEditRequiredKeywordModalState'
import { useEditCrawlSettingModalQuery } from '@/features/products/hooks/useEditCrawlSettingModalState'
import { useEditExcludeKeywordModalQuery } from '@/features/products/hooks/useEditExcludeKeywordModalState'
import { useEditExcludeProductModalQuery } from '@/features/products/hooks/useEditExcludeProductModalState'
import { useEditRequiredKeywordModalQuery } from '@/features/products/hooks/useEditRequiredKeywordModalState'
import { pageStateCache, usePageStateQuery } from '@/features/products/hooks/usePageState'
import { usePerStateQuery, perStateCache } from '@/features/products/hooks/usePerState'
import {
  platformStateCache,
  usePlatformStateQuery,
} from '@/features/products/hooks/usePlatformState'
import { statusStateCache, useStatusStateQuery } from '@/features/products/hooks/useStatusState'
import { makePlatformMask } from '@/features/products/lib/makePlatformMask'
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
  const { [usePlatformStateQuery]: platform } = platformStateCache.parse(searchParams)
  const { [useStatusStateQuery]: status } = statusStateCache.parse(searchParams)
  const { [usePageStateQuery]: page } = pageStateCache.parse(searchParams)
  const { [usePerStateQuery]: per } = perStateCache.parse(searchParams)

  const { data } = await getClient().query<GetProductDetailPageDataQuery>({
    query: GetProductDetailPageDataDocument,
    variables: {
      id: params.id,
      platformMask: makePlatformMask(platform, status),
      page: page,
      per: per,
      sort: status == 'published' ? 'price' : 'bought_date',
      order: status == 'published' ? 'asc' : 'desc',
    },
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>設定</h2>
            <div className='grid grid-cols-2 md:grid-cols-4 gap-4'>
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
                    [useEditRequiredKeywordModalQuery]: 'true',
                  },
                }}
              >
                必須キーワード
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
                    [useEditExcludeProductModalQuery]: 'true',
                  },
                }}
              >
                除外商品ID
              </Link>
            </div>
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>一括設定</h2>
            <div className='grid grid-cols-2 md:grid-cols-4 gap-4'>
              <Link
                className='btn'
                href={{
                  pathname: `/products/${params.id}`,
                  query: {
                    ...searchParams,
                    [useBulkEditRequiredKeywordModalQuery]: 'true',
                  },
                }}
              >
                必須キーワード
              </Link>
              <Link
                className='btn'
                href={{
                  pathname: `/products/${params.id}`,
                  query: {
                    ...searchParams,
                    [useBulkEditExcludeKeywordModalQuery]: 'true',
                  },
                }}
              >
                除外キーワード
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
            <div className='pt-4 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4'>
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
          iosys_crawl_setting: {
            keyword: data.product.iosysCrawlSetting?.keyword,
            min_price: data.product.iosysCrawlSetting?.minPrice,
            max_price: data.product.iosysCrawlSetting?.maxPrice,
            enabled: data.product.iosysCrawlSetting?.enabled,
          },
          pc_koubou_crawl_setting: {
            keyword: data.product.pcKoubouCrawlSetting?.keyword,
            min_price: data.product.pcKoubouCrawlSetting?.minPrice,
            max_price: data.product.pcKoubouCrawlSetting?.maxPrice,
            enabled: data.product.pcKoubouCrawlSetting?.enabled,
          },
        }}
      />
      <EditExcludeKeywordModal data={data} />
      <EditExcludeProductModal data={data} />
      <EditRequiredKeywordModal data={data} />
      <BulkEditExcludeKeywordModal
        yahooAuctionCrawlSettingExcludeKeywords={
          data.product.yahooAuctionCrawlSetting.yahooAuctionCrawlSettingExcludeKeywords
        }
        mercariCrawlSettingExcludeKeywords={
          data.product.mercariCrawlSetting.mercariCrawlSettingExcludeKeywords
        }
        janparaCrawlSettingExcludeKeywords={
          data.product.janparaCrawlSetting.janparaCrawlSettingExcludeKeywords
        }
        iosysCrawlSettingExcludeKeywords={
          data.product.iosysCrawlSetting.iosysCrawlSettingExcludeKeywords
        }
        pcKoubouCrawlSettingExcludeKeywords={
          data.product.pcKoubouCrawlSetting.pcKoubouCrawlSettingExcludeKeywords
        }
      />
      <BulkEditRequiredKeywordModal
        yahooAuctionCrawlSettingRequiredKeywords={
          data.product.yahooAuctionCrawlSetting.yahooAuctionCrawlSettingRequiredKeywords
        }
        mercariCrawlSettingRequiredKeywords={
          data.product.mercariCrawlSetting.mercariCrawlSettingRequiredKeywords
        }
        janparaCrawlSettingRequiredKeywords={
          data.product.janparaCrawlSetting.janparaCrawlSettingRequiredKeywords
        }
        iosysCrawlSettingRequiredKeywords={
          data.product.iosysCrawlSetting.iosysCrawlSettingRequiredKeywords
        }
        pcKoubouCrawlSettingRequiredKeywords={
          data.product.pcKoubouCrawlSetting.pcKoubouCrawlSettingRequiredKeywords
        }
      />
    </Layout>
  )
}

export default Page
