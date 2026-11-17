import Layout from '@/components/layouts/Layout'
import {
  getDailyMarketPrices,
  getMonitorCrawlResults,
  getMonitors,
} from '@/features/product-monitoring/api/actions'
import MonitorList from '@/features/product-monitoring/components/MonitorList'

const Page = async () => {
  const [response, aggregationResponse] = await Promise.all([
    getMonitors(),
    getDailyMarketPrices().catch(() => null),
  ])
  if (!response.data) throw new Error('モニタリング設定を取得できませんでした')

  const sections = await Promise.all(
    response.data.monitors.map(async (monitor) => {
      const crawlResults = await getMonitorCrawlResults(monitor.id).catch(() => null)
      return {
        monitor,
        crawlResults: crawlResults?.data ? crawlResults.data.crawlResults : null,
        dailyMarketPrices: aggregationResponse?.data
          ? aggregationResponse.data.dailyMarketPrices.filter((item) => item.monitorId === monitor.id)
          : null,
      }
    }),
  )

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <MonitorList sections={sections} />
        </div>
      </div>
    </Layout>
  )
}

export default Page
