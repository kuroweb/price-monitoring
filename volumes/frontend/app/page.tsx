import Layout from '@/components/layouts/Layout'
import ProductsCard from '@/features/products/components/ProductsCard'
import CreateCrawlSettingModal from '@/features/products/components/create-crawl-setting-modal/CreateCrawlSettingModal'
import { GetProductPageDataDocument, GetProductPageDataQuery, Product } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async () => {
  const { data } = await getClient().query<GetProductPageDataQuery>({
    query: GetProductPageDataDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <ProductsCard data={data} />
      </div>
      <CreateCrawlSettingModal />
    </Layout>
  )
}

export default Page
