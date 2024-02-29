import Layout from '@/components/layouts/Layout'
import CreateCrawlSettingModal from '@/features/products/components/CreateCrawlSettingModal/Index'
import EditCrawlSettingModal from '@/features/products/components/EditCrawlSettingModal/Index'
import ProductsCard from '@/features/products/components/ProductsCard'
import { GetProductsDocument, GetProductsQuery } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async () => {
  const { data } = await getClient().query<GetProductsQuery>({
    query: GetProductsDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <ProductsCard data={data} />
      </div>
      <CreateCrawlSettingModal />
      <EditCrawlSettingModal />
    </Layout>
  )
}

export default Page
