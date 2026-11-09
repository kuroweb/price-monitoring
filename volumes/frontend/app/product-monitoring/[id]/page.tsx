import { notFound } from 'next/navigation'

import Layout from '@/components/layouts/Layout'
import {
  getAllProductAggregationResults,
  getProductAggregationPurchases,
  getProductWatchResults,
  getProductWatchSettings,
} from '@/features/product-monitoring/api/actions'
import ProductWatchDetail from '@/features/product-monitoring/components/ProductWatchDetail'

const Page = async ({ params }: { params: Promise<{ id: string }> }) => {
  const rawId = (await params).id
  const id = Number(rawId)
  if (!/^[1-9]\d*$/.test(rawId) || !Number.isSafeInteger(id)) notFound()

  const [settingsResponse, resultsResponse, aggregationResponse] = await Promise.all([
    getProductWatchSettings(),
    getProductWatchResults(id).catch(() => null),
    getAllProductAggregationResults().catch(() => null),
  ])
  if (!settingsResponse.data) throw new Error('商品モニタリング設定を取得できませんでした')
  const setting = settingsResponse.data.productWatchSettings.find((item) => item.id === id)
  if (!setting) notFound()

  const daily = aggregationResponse?.data
    ? aggregationResponse.data.productAggregationResults.filter((item) => item.productWatchSettingId === id)
    : null
  const purchases = daily?.length
    ? await getProductAggregationPurchases(id, {
        startDate: daily[0].date,
        endDate: daily[daily.length - 1].date,
      }).catch(() => null)
    : null

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <ProductWatchDetail
            setting={setting}
            results={resultsResponse?.data?.productCrawlResults ?? null}
            daily={daily}
            purchases={daily?.length ? (purchases?.data?.productCrawlResults ?? null) : []}
            discordConfigured={settingsResponse.data.discordConfigured}
          />
        </div>
      </div>
    </Layout>
  )
}

export default Page
