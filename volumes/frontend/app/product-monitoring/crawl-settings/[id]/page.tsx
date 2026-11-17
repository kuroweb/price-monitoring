import Link from 'next/link'
import { notFound } from 'next/navigation'

import Layout from '@/components/layouts/Layout'
import { getCrawlResults, getCrawlSetting } from '@/features/product-monitoring/api/actions'
import CrawlSettingDetail from '@/features/product-monitoring/components/CrawlSettingDetail'

const Page = async ({ params }: { params: Promise<{ id: string }> }) => {
  const id = Number((await params).id)
  if (!Number.isSafeInteger(id)) notFound()

  const [settingResponse, resultsResponse] = await Promise.all([
    getCrawlSetting(id),
    getCrawlResults({ crawlSettingId: id }),
  ])
  if (settingResponse.status === 404) notFound()
  if (!settingResponse.data || !resultsResponse.data)
    throw new Error('収集結果を取得できませんでした')

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <div className='breadcrumbs p-0 text-sm'>
            <ul>
              <li>
                <Link href='/product-monitoring/crawl-settings'>収集設定</Link>
              </li>
              <li>{settingResponse.data.name}</li>
            </ul>
          </div>
          <h2 className='card-title'>{settingResponse.data.name}</h2>
          <CrawlSettingDetail
            crawlSetting={settingResponse.data}
            crawlResults={resultsResponse.data.crawlResults ?? []}
          />
        </div>
      </div>
    </Layout>
  )
}

export default Page
