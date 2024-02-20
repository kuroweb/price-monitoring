import Layout from '@/components/layouts/Layout'
import CrawlSettingModal from '@/features/products/components/CrawlSettingModal'
import ExcludeConditionModal from '@/features/products/components/ExcludeConditionModal'
import CalculateDailyYahooAuctionProductChart from '@/features/products/components/YahooAuctionProductChart'
import YahooAuctionProductsTable from '@/features/products/components/YahooAuctionProductsTable'
import {
  GetProductDetailPageDataDocument,
  GetProductDetailPageDataQuery,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async ({ params }: { params: { id: string } }) => {
  const { data, error } = await getClient().query<GetProductDetailPageDataQuery>({
    query: GetProductDetailPageDataDocument,
    variables: { id: params.id, published: true },
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>設定</h2>
            <div className='grid grid-cols-2 gap-4'>
              <CrawlSettingModal data={data} />
              <ExcludeConditionModal data={data} />
            </div>
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>ヤフオク</h2>
            <CalculateDailyYahooAuctionProductChart data={data} />
            <YahooAuctionProductsTable data={data} error={error} />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
