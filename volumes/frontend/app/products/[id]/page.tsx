import Layout from '@/components/layouts/Layout'
import ProductTable from '@/components/products/ProductTable'
import YahooAuctionProductsTable from '@/components/products/YahooAuctionProductsTable'
import { ProductDocument, ProductQuery } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async ({
  params,
  searchParams,
}: {
  params: { id: string }
  searchParams: { [key: string]: string | string[] | undefined }
}) => {
  const { data, error } = await getClient().query<ProductQuery>({
    query: ProductDocument,
    variables: { id: params.id, published: true },
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
      <ProductTable data={data} error={error} />
      {/* TODO: 別コンポーネントに切り出す */}
      <ol className='flex items-center whitespace-nowrap min-w-0 pt-4' aria-label='Breadcrumb'>
        <li className='text-sm text-gray-500'>
          <div className='flex items-center'>
            <span className='font-semibold'>ヤフオク</span>
          </div>
        </li>
      </ol>
      <YahooAuctionProductsTable data={data} error={error} />
    </Layout>
  )
}

export default Page
