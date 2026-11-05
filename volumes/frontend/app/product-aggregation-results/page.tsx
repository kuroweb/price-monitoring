import Layout from '@/components/layouts/Layout'
import ProductAggregationResultsSection from '@/features/product-aggregation-results/components/ProductAggregationResultsSection'
import { getAllProductAggregationResults, getProductAggregationSettings } from '@/lib/actions'

const Page = async () => {
  const [settingsResponse, resultsResponse] = await Promise.all([
    getProductAggregationSettings(),
    getAllProductAggregationResults(),
  ])
  if (!settingsResponse.data || !resultsResponse.data)
    throw new Error('商品相場を取得できませんでした')

  const productAggregationSettings = settingsResponse.data.productAggregationSettings ?? []
  const productAggregationResults = resultsResponse.data.productAggregationResults ?? []

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <h2 className='card-title'>商品相場</h2>
          <div className='space-y-8 pt-4'>
            {productAggregationSettings.length === 0 && (
              <p>商品相場設定はまだありません。管理画面で商品相場設定を追加してください。</p>
            )}
            {productAggregationSettings.map((setting) => (
              <ProductAggregationResultsSection
                key={setting.id}
                productAggregationSetting={setting}
                productAggregationResults={productAggregationResults.filter(
                  (result) => result.productAggregationSettingId === setting.id,
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
