import Layout from '@/components/layouts/Layout'
import {
  getMonitorCrawlResults,
  getMonitorSummary,
  getMonitors,
} from '@/features/product-monitoring/api/actions'
import MonitorList from '@/features/product-monitoring/components/MonitorList'

const Page = async () => {
  const response = await getMonitors()
  if (!response.data) throw new Error('モニタリング設定を取得できませんでした')

  const sections = await Promise.all(
    response.data.monitors.map(async (monitor) => {
      const [crawlResults, summary] = await Promise.all([
        getMonitorCrawlResults(monitor.id).catch(() => null),
        getMonitorSummary(monitor.id).catch(() => null),
      ])
      return {
        monitor,
        crawlResults: crawlResults?.data ? crawlResults.data.crawlResults : null,
        summary: summary?.data ?? null,
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
