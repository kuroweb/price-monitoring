import Layout from '@/components/layouts/Layout'
import ConfigCard from '@/features/products/components/ConfigCard'
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
        <ConfigCard />
        <ProductsCard data={data} />
        <CreateCrawlSettingModal />
      </div>
    </Layout>
  )
}

export default Page
