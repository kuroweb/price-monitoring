import Layout from '@/components/layouts/Layout'
import {
  getCrawlResults,
  getCrawlSettings,
} from '@/features/product-monitoring/api/actions'
import CrawlSettingAddButton from '@/features/product-monitoring/components/CrawlSettingAddButton'
import CrawlSettingSection from '@/features/product-monitoring/components/CrawlSettingSection'

const Page = async () => {
  const [settingsResponse, resultsResponse] = await Promise.all([
    getCrawlSettings(),
    getCrawlResults(),
  ])
  if (!settingsResponse.data || !resultsResponse.data)
    throw new Error('収集結果を取得できませんでした')

  const crawlSettings = settingsResponse.data.crawlSettings ?? []
  const crawlResults = resultsResponse.data.crawlResults ?? []

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <div className='flex flex-wrap items-center justify-between gap-2'>
            <h2 className='card-title'>収集設定</h2>
            <CrawlSettingAddButton />
          </div>
          <div className='divide-y divide-base-200 pt-4 [&>section]:py-5 [&>section:first-child]:pt-0'>
            {crawlSettings.length === 0 && (
              <div>
                収集設定はまだありません。
                <CrawlSettingAddButton className='link' />
                してください。
              </div>
            )}
            {crawlSettings.map((setting) => (
              <CrawlSettingSection
                key={setting.id}
                crawlSetting={setting}
                crawlResults={crawlResults.filter(
                  (result) => result.crawlSettingId === setting.id,
                )}
              />
            ))}
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
