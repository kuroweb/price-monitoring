import Layout from '@/components/layouts/Layout'
import {
  getAllProductAggregationResults,
  getProductAggregationPurchases,
  getProductAggregationSettings,
} from '@/features/product-monitoring/api/actions'
import type { ProductAggregationResult } from '@/features/product-monitoring/api/types'
import ProductAggregationResultsSection from '@/features/product-monitoring/components/ProductAggregationResultsSection'
import ProductAggregationSettingAddButton from '@/features/product-monitoring/components/ProductAggregationSettingAddButton'

// 保存済みの商品日次相場と同じ期間の購入を取る。日次相場がなければ取らない
// 取得に失敗しても日次相場は表示できるよう、ページ全体は失敗させず null を返す
const getPurchases = async (id: number, results: ProductAggregationResult[]) => {
  if (results.length === 0) return []

  const response = await getProductAggregationPurchases(id, {
    startDate: results[0].date,
    endDate: results[results.length - 1].date,
  })
  return response.data ? (response.data.productCrawlResults ?? []) : null
}

const Page = async () => {
  const [settingsResponse, resultsResponse] = await Promise.all([
    getProductAggregationSettings(),
    getAllProductAggregationResults(),
  ])
  if (!settingsResponse.data || !resultsResponse.data)
    throw new Error('商品相場を取得できませんでした')

  const productAggregationSettings = settingsResponse.data.productAggregationSettings ?? []
  const productAggregationResults = resultsResponse.data.productAggregationResults ?? []
  const sections = await Promise.all(
    productAggregationSettings.map(async (setting) => {
      const results = productAggregationResults.filter(
        (result) => result.productAggregationSettingId === setting.id,
      )
      return { setting, results, purchases: await getPurchases(setting.id, results) }
    }),
  )

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <div className='flex flex-wrap items-center justify-between gap-2'>
            <h2 className='card-title'>商品相場</h2>
            <ProductAggregationSettingAddButton />
          </div>
          <div className='space-y-8 pt-4'>
            {productAggregationSettings.length === 0 && (
              <div>
                商品相場設定はまだありません。
                <ProductAggregationSettingAddButton className='link' />
                してください。
              </div>
            )}
            {sections.map(({ setting, results, purchases }) => (
              <ProductAggregationResultsSection
                key={setting.id}
                productAggregationSetting={setting}
                productAggregationResults={results}
                productAggregationPurchases={purchases}
              />
            ))}
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
