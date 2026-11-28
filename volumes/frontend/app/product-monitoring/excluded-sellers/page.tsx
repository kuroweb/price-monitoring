import Layout from '@/components/layouts/Layout'
import { getExcludedSellers } from '@/features/product-monitoring/api/actions'
import ExcludedSellerList from '@/features/product-monitoring/components/ExcludedSellerList'

const Page = async () => {
  const response = await getExcludedSellers()
  if (!response.data) throw new Error('除外する出品者を取得できませんでした')

  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <h2 className='card-title'>除外する出品者</h2>
          <ExcludedSellerList excludedSellers={response.data.excludedSellers} />
        </div>
      </div>
    </Layout>
  )
}

export default Page
