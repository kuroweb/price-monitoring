import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import EditProductModal from '@/features/products/components/EditProductModal'
import CalculateDailyYahooAuctionProductChart from '@/features/products/components/YahooAuctionProductChart'
import YahooAuctionProductsTable from '@/features/products/components/YahooAuctionProductsTable'
import ExcludeKeywordModal from '@/features/products/components/exclude-keyword-modal/ExcludeKeywordModal'
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
              <EditProductModal data={data} />
              <ExcludeKeywordModal data={data} />
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
    </Layout>
  )
}

export default Page
