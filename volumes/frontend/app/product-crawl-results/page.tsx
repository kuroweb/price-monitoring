import Layout from '@/components/layouts/Layout'
import {
  getProductCrawlResults,
  getProductCrawlSettings,
} from '@/features/product-monitoring/api/actions'
import ProductCrawlResultsSection from '@/features/product-monitoring/components/ProductCrawlResultsSection'
import ProductCrawlSettingAddButton from '@/features/product-monitoring/components/ProductCrawlSettingAddButton'

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
          <div className='flex flex-wrap items-center justify-between gap-2'>
            <h2 className='card-title'>商品計測結果</h2>
            <ProductCrawlSettingAddButton />
          </div>
          <div className='divide-y divide-base-200 pt-4 [&>section]:py-5 [&>section:first-child]:pt-0'>
            {productCrawlSettings.length === 0 && (
              <div>
                商品計測設定はまだありません。
                <ProductCrawlSettingAddButton className='link' />
                してください。
              </div>
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
