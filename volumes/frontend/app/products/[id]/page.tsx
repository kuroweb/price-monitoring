import Layout from '@/components/layouts/Layout'
import Breadcrumbs from '@/components/ui/Breadcrumbs'
import ProductTable from '@/features/products/components/ProductTable'
import UpdateForm from '@/features/products/components/UpdateForm'
import YahooAuctionProductsTable from '@/features/products/components/YahooAuctionProductsTable'
import {
  GetProductWithAssociationDocument,
  GetProductWithAssociationQuery,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async ({ params }: { params: { id: string } }) => {
  const { data, error } = await getClient().query<GetProductWithAssociationQuery>({
    query: GetProductWithAssociationDocument,
    variables: { id: params.id, published: true },
  })

  return (
    <Layout>
      <Breadcrumbs text={'監視設定'} />
      <UpdateForm data={data} />
      <Breadcrumbs text={'ヤフオク'} className='pt-4' />
      <YahooAuctionProductsTable data={data} error={error} />
    </Layout>
  )
}

export default Page
