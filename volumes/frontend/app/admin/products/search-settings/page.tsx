import Layout from '@/components/layouts/Layout'
import ProductSearchSettings from '@/features/admin/products/search-settings/ProductSearchSettings'
import { getProductSearchSettings } from '@/lib/actions'
export default async function Page() {
  const response = await getProductSearchSettings()
  if (response.status < 200 || response.status >= 300 || !response.data)
    throw new Error('URL計測設定を取得できませんでした')
  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <h2 className='card-title'>URLによる計測設定</h2>
          <ProductSearchSettings initial={response.data.products ?? []} />
        </div>
      </div>
    </Layout>
  )
}
