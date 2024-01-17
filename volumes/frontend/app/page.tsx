import Layout from '@/components/layouts/Layout'
import Breadcrumbs from '@/components/ui/Breadcrumbs'
import CreateForm from '@/features/products/components/CreateForm'
import ProductsTable from '@/features/products/components/ProductsTable'
import { ProductsDocument, ProductsQuery } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async () => {
  const { data, error } = await getClient().query<ProductsQuery>({
    query: ProductsDocument,
  })

  return (
    <Layout>
      <Breadcrumbs text={'Create Form'} />
      <CreateForm />
      <Breadcrumbs text={'Products'} className='pt-4' />
      <ProductsTable data={data} error={error} />
    </Layout>
  )
}

export default Page
