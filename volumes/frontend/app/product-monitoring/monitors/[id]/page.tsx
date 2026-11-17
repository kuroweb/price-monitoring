import { notFound } from 'next/navigation'

import Layout from '@/components/layouts/Layout'
import {
  getDailyMarketPrices,
  getMonitorTransactions,
  getMonitorCrawlResults,
  getMonitors,
} from '@/features/product-monitoring/api/actions'
import MonitorDetail from '@/features/product-monitoring/components/MonitorDetail'

const Page = async ({ params }: { params: Promise<{ id: string }> }) => {
  const rawId = (await params).id
  const id = Number(rawId)
  if (!/^[1-9]\d*$/.test(rawId) || !Number.isSafeInteger(id)) notFound()

  const [settingsResponse, resultsResponse, aggregationResponse] = await Promise.all([
    getMonitors(),
    getMonitorCrawlResults(id).catch(() => null),
    getDailyMarketPrices().catch(() => null),
  ])
  if (!settingsResponse.data) throw new Error('モニタリング設定を取得できませんでした')
  const monitor = settingsResponse.data.monitors.find((item) => item.id === id)
  if (!monitor) notFound()

  const allDaily = aggregationResponse?.data
    ? aggregationResponse.data.dailyMarketPrices.filter((item) => item.monitorId === id)
    : null
  const latestDate = allDaily?.at(-1)?.date
  const firstDate = latestDate ? new Date(`${latestDate}T00:00:00Z`) : null
  firstDate?.setUTCDate(firstDate.getUTCDate() - 29)
  const dailyMarketPrices = allDaily?.filter((item) => item.date >= firstDate!.toISOString().slice(0, 10)) ?? null
  const transactions = dailyMarketPrices?.length
    ? await getMonitorTransactions(id, {
        startDate: dailyMarketPrices[0].date,
        endDate: dailyMarketPrices[dailyMarketPrices.length - 1].date,
      }).catch(() => null)
    : null

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <MonitorDetail
            monitor={monitor}
            crawlResults={resultsResponse?.data?.crawlResults ?? null}
            dailyMarketPrices={dailyMarketPrices}
            transactions={dailyMarketPrices?.length ? (transactions?.data?.transactions ?? null) : []}
            discordConfigured={settingsResponse.data.discordConfigured}
          />
        </div>
      </div>
    </Layout>
  )
}

export default Page
