import Layout from '@/components/layouts/Layout'
import Breadcrumbs from '@/components/ui/Breadcrumbs'
import ProductTable from '@/features/products/components/ProductTable'
import YahooAuctionProductsTable from '@/features/products/components/YahooAuctionProductsTable'
import {
  GetProductWithYahooAuctionProductsDocument,
  GetProductWithYahooAuctionProductsQuery,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async ({
  params,
  searchParams,
}: {
  params: { id: string }
  searchParams: { [key: string]: string | string[] | undefined }
}) => {
  const { data, error } = await getClient().query<GetProductWithYahooAuctionProductsQuery>({
    query: GetProductWithYahooAuctionProductsDocument,
    variables: { id: params.id, published: true },
  })

  return (
    <Layout>
      <Breadcrumbs text={'Products'} />
      <ProductTable data={data} error={error} />
      <Breadcrumbs text={'ヤフオク'} className='pt-4' />
      <YahooAuctionProductsTable data={data} error={error} />
    </Layout>
  )
}

export default Page
