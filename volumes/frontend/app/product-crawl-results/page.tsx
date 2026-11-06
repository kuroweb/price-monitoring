import Layout from '@/components/layouts/Layout'
import { getProductCrawlResults, getProductCrawlSettings } from '@/features/product-monitoring/api/actions'
import ProductCrawlResultsSection from '@/features/product-monitoring/components/ProductCrawlResultsSection'

const Page = async () => {
  const [settingsResponse, resultsResponse] = await Promise.all([
    getProductCrawlSettings(),
    getProductCrawlResults(),
  ])
  if (!settingsResponse.data || !resultsResponse.data)
    throw new Error('商品計測結果を取得できませんでした')

  const productCrawlSettings = settingsResponse.data.productCrawlSettings ?? []
  const productCrawlResults = resultsResponse.data.productCrawlResults ?? []

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <h2 className='card-title'>商品計測結果</h2>
          <div className='divide-y divide-base-200 pt-2 [&>*]:py-5'>
            {productCrawlSettings.length === 0 && (
              <p>商品計測設定はまだありません。管理画面で商品計測設定を追加してください。</p>
            )}
            {productCrawlSettings.map((setting) => (
              <ProductCrawlResultsSection
                key={setting.id}
                productCrawlSetting={setting}
                productCrawlResults={productCrawlResults.filter(
                  (result) => result.productCrawlSettingId === setting.id,
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
