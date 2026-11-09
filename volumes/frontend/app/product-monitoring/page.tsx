import Layout from '@/components/layouts/Layout'
import {
  getAllProductAggregationResults,
  getProductWatchResults,
  getProductWatchSettings,
} from '@/features/product-monitoring/api/actions'
import ProductWatchSettings from '@/features/product-monitoring/components/ProductWatchSettings'

const Page = async () => {
  const [response, aggregationResponse] = await Promise.all([
    getProductWatchSettings(),
    getAllProductAggregationResults().catch(() => null),
  ])
  if (!response.data) throw new Error('商品モニタリング設定を取得できませんでした')

  const sections = await Promise.all(
    response.data.productWatchSettings.map(async (setting) => {
      const results = await getProductWatchResults(setting.id).catch(() => null)
      return {
        setting,
        results: results?.data ? results.data.productCrawlResults : null,
        daily: aggregationResponse?.data
          ? aggregationResponse.data.productAggregationResults.filter((item) => item.productWatchSettingId === setting.id)
          : null,
      }
    }),
  )

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <ProductWatchSettings sections={sections} />
        </div>
      </div>
    </Layout>
  )
}

export default Page
