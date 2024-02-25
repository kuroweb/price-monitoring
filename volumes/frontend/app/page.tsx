import Layout from '@/components/layouts/Layout'
import CreateProductModal from '@/features/products/components/CreateProductModal'
import ProductsTable from '@/features/products/components/ProductsTable'
import { GetProductsDocument, GetProductsQuery } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async () => {
  const { data, error } = await getClient().query<GetProductsQuery>({
    query: GetProductsDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <CreateProductModal />
            <h2 className='card-title py-4'>計測対象一覧</h2>
            <ProductsTable data={data} error={error} />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
