import Layout from '@/components/layouts/Layout'
import Breadcrumbs from '@/components/ui/Breadcrumbs'
import ProductsTable from '@/features/products/ProductsTable'
import { ProductsDocument, ProductsQuery } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async () => {
  const { data, error } = await getClient().query<ProductsQuery>({
    query: ProductsDocument,
  })

  return (
    <Layout>
      <Breadcrumbs text={'Products'} />
      <ProductsTable data={data} error={error} />
    </Layout>
  )
}

export default Page
