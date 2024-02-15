import Layout from '@/components/layouts/Layout'
import Breadcrumbs from '@/components/ui/Breadcrumbs'
import CreateForm from '@/features/products/components/CreateForm'
import ProductsTable from '@/features/products/components/ProductsTable'
import { GetProductsDocument, GetProductsQuery } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async () => {
  const { data, error } = await getClient().query<GetProductsQuery>({
    query: GetProductsDocument,
  })

  return (
    <Layout>
      <div className='grid sm:grid-cols-1 lg:grid-cols-2 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title'>登録フォーム</h2>
            <CreateForm />
          </div>
        </div>
        <ProductsTable data={data} error={error} />
      </div>
    </Layout>
  )
}

export default Page
