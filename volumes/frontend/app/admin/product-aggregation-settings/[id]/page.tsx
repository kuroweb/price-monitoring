import Link from 'next/link'
import { notFound } from 'next/navigation'

import Layout from '@/components/layouts/Layout'
import ProductAggregationResults from '@/features/admin/product-aggregation-settings/components/ProductAggregationResults'
import { getProductAggregationResults, getProductAggregationSetting } from '@/lib/actions'

const Page = async ({ params }: { params: Promise<{ id: string }> }) => {
  const id = Number((await params).id)
  if (!Number.isSafeInteger(id)) notFound()

  const [settingResponse, resultsResponse] = await Promise.all([
    getProductAggregationSetting(id),
    getProductAggregationResults(id),
  ])
  if (settingResponse.status === 404) notFound()
  if (!settingResponse.data || !resultsResponse.data)
    throw new Error('商品日次相場を取得できませんでした')

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <Link className='link' href='/admin/product-aggregation-settings'>
            商品相場設定一覧へ戻る
          </Link>
          <h2 className='card-title'>商品相場: {settingResponse.data.name}</h2>
          <ProductAggregationResults
            productAggregationSetting={settingResponse.data}
            productAggregationResults={resultsResponse.data.productAggregationResults ?? []}
          />
        </div>
      </div>
    </Layout>
  )
}

export default Page
