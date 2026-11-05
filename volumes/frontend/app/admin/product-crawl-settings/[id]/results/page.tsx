import Link from 'next/link'
import { notFound } from 'next/navigation'

import Layout from '@/components/layouts/Layout'
import ProductCrawlResults from '@/features/admin/product-crawl-settings/components/ProductCrawlResults'
import { getProductCrawlResults, getProductCrawlSetting } from '@/lib/actions'

const Page = async ({ params }: { params: Promise<{ id: string }> }) => {
  const id = Number((await params).id)
  if (!Number.isSafeInteger(id)) notFound()

  const [settingResponse, resultsResponse] = await Promise.all([
    getProductCrawlSetting(id),
    getProductCrawlResults(id),
  ])
  if (settingResponse.status === 404) notFound()
  if (!settingResponse.data || !resultsResponse.data)
    throw new Error('商品計測結果を取得できませんでした')

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <Link className='link' href='/admin/product-crawl-settings'>
            商品計測設定一覧へ戻る
          </Link>
          <h2 className='card-title'>商品計測結果: {settingResponse.data.name}</h2>
          <ProductCrawlResults
            productCrawlSetting={settingResponse.data}
            productCrawlResults={resultsResponse.data.productCrawlResults ?? []}
          />
        </div>
      </div>
    </Layout>
  )
}

export default Page
