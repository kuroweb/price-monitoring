import Layout from '@/components/layouts/Layout'
import ProductCrawlSettings from '@/features/admin/product-crawl-settings/components/ProductCrawlSettings'
import { getProductCrawlSettings } from '@/lib/actions'

const Page = async () => {
  const response = await getProductCrawlSettings()
  if (response.status < 200 || response.status >= 300 || !response.data)
    throw new Error('商品計測設定を取得できませんでした')

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <h2 className='card-title'>商品計測設定</h2>
          <ProductCrawlSettings initial={response.data.productCrawlSettings ?? []} />
        </div>
      </div>
    </Layout>
  )
}

export default Page
