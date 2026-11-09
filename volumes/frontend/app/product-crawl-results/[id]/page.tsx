import Link from 'next/link'
import { notFound } from 'next/navigation'

import Layout from '@/components/layouts/Layout'
import { getProductCrawlResults, getProductCrawlSetting } from '@/features/product-monitoring/api/actions'
import ProductCrawlResultsDetail from '@/features/product-monitoring/components/ProductCrawlResultsDetail'

const Page = async ({ params }: { params: Promise<{ id: string }> }) => {
  const id = Number((await params).id)
  if (!Number.isSafeInteger(id)) notFound()

  const [settingResponse, resultsResponse] = await Promise.all([
    getProductCrawlSetting(id),
    getProductCrawlResults({ productCrawlSettingId: id }),
  ])
  if (settingResponse.status === 404) notFound()
  if (!settingResponse.data || !resultsResponse.data)
    throw new Error('商品計測結果を取得できませんでした')

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <div className='breadcrumbs p-0 text-sm'>
            <ul>
              <li>
                <Link href='/product-crawl-results'>商品計測</Link>
              </li>
              <li>{settingResponse.data.name}</li>
            </ul>
          </div>
          <h2 className='card-title'>{settingResponse.data.name}</h2>
          <ProductCrawlResultsDetail
            productCrawlSetting={settingResponse.data}
            productCrawlResults={resultsResponse.data.productCrawlResults ?? []}
          />
        </div>
      </div>
    </Layout>
  )
}

export default Page
