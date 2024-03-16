import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import MercariProductsTable from '@/features/products/components/MercariProductsTable'
import CalculateDailyYahooAuctionProductChart from '@/features/products/components/YahooAuctionProductChart'
import YahooAuctionProductsTable from '@/features/products/components/YahooAuctionProductsTable'
import EditCrawlSettingModal from '@/features/products/components/edit-crawl-setting-modal/EditCrawlSettingModal'
import EditExcludeKeywordModal from '@/features/products/components/edit-exclude-keyword-modal/EditExcludeKeywordModal'
import { useEditCrawlSettingModalQuery } from '@/features/products/hooks/useEditCrawlSettingModalState'
import { useEditExcludeKeywordModalQuery } from '@/features/products/hooks/useEditExcludeKeywordModalState'
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
  const published = searchParams.published ? searchParams.published === 'true' : true

  const { data, error } = await getClient().query<GetProductDetailPageDataQuery>({
    query: GetProductDetailPageDataDocument,
    variables: {
      id: params.id,
      published: published,
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
              <EditExcludeKeywordModal data={data} />
            </div>
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>相場グラフ</h2>
            <CalculateDailyYahooAuctionProductChart data={data} />
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>メルカリ</h2>
            <div className='flex justify-end'>
              {published ? (
                <>
                  <Link href={`/products/${params.id}?published=false`} className='btn btn-link'>
                    落札一覧に切り替え
                  </Link>
                </>
              ) : (
                <>
                  <Link href={`/products/${params.id}?published=true`} className='btn btn-link'>
                    出品一覧に切り替え
                  </Link>
                </>
              )}
            </div>
            <MercariProductsTable data={data} />
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>ヤフオク</h2>
            <div className='flex justify-end'>
              {published ? (
                <>
                  <Link href={`/products/${params.id}?published=false`} className='btn btn-link'>
                    落札一覧に切り替え
                  </Link>
                </>
              ) : (
                <>
                  <Link href={`/products/${params.id}?published=true`} className='btn btn-link'>
                    出品一覧に切り替え
                  </Link>
                </>
              )}
            </div>
            <YahooAuctionProductsTable data={data} error={error} />
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
        }}
      />
    </Layout>
  )
}

export default Page
