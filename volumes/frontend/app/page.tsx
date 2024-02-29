import Layout from '@/components/layouts/Layout'
import ProductsCard from '@/features/products/components/ProductsCard'
import CreateCrawlSettingModal from '@/features/products/components/create-crawl-setting-modal/CreateCrawlSettingModal'
import EditCrawlSettingModal from '@/features/products/components/edit-crawl-setting-modal/EditCrawlSettingModal'
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
