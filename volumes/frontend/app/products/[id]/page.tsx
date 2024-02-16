import Layout from '@/components/layouts/Layout'
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
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <UpdateForm data={data} />
            <h2 className='card-title py-4'>ヤフオク</h2>
            <YahooAuctionProductsTable data={data} error={error} />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
