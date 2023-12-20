import Layout from '@/components/layouts/Layout'
import ProductsTable from '@/components/products/ProductsTable'
import { ProductsDocument, ProductsQuery } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async () => {
  const { data, error } = await getClient().query<ProductsQuery>({
    query: ProductsDocument,
  })

  return (
    <Layout>
      {/* TODO: 別コンポーネントに切り出す */}
      <ol className='flex items-center whitespace-nowrap min-w-0' aria-label='Breadcrumb'>
        <li className='text-sm text-gray-500'>
          <div className='flex items-center'>
            <span className='font-semibold'>Products</span>
          </div>
        </li>
      </ol>
      <ProductsTable data={data} error={error} />
    </Layout>
  )
}

export default Page
