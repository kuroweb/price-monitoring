import Layout from '@/components/layouts/Layout'
import ProductAggregationSettings from '@/features/admin/product-aggregation-settings/components/ProductAggregationSettings'
import { getProductAggregationSettings } from '@/lib/actions'

const Page = async () => {
  const response = await getProductAggregationSettings()
  if (response.status < 200 || response.status >= 300 || !response.data)
    throw new Error('商品相場設定を取得できませんでした')

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <h2 className='card-title'>商品相場設定</h2>
          <ProductAggregationSettings
            productAggregationSettings={response.data.productAggregationSettings ?? []}
          />
        </div>
      </div>
    </Layout>
  )
}

export default Page
