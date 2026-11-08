import Layout from '@/components/layouts/Layout'
import {
  getProductWatchResults,
  getProductWatchSettings,
} from '@/features/product-monitoring/api/actions'
import ProductWatchSettings from '@/features/product-monitoring/components/ProductWatchSettings'

const Page = async () => {
  const response = await getProductWatchSettings()
  if (!response.data) throw new Error('商品モニタリング設定を取得できませんでした')

  const sections = await Promise.all(
    response.data.productWatchSettings.map(async (setting) => {
      const results = await getProductWatchResults(setting.id)
      return { setting, results: results.data ? results.data.productCrawlResults : null }
    }),
  )

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <ProductWatchSettings
            sections={sections}
          />
        </div>
      </div>
    </Layout>
  )
}

export default Page
