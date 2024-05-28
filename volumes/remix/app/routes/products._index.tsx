import { useTypedLoaderData } from 'remix-typedjson'

import ProductsTable from '../../features/products/components/ProductsTable'

import type { LoaderFunction } from '@remix-run/node'

import { GetProductPageDataDocument, GetProductPageDataQuery } from '@/graphql/dist/client'
import client from '@/lib/apollo-client'

export const loader: LoaderFunction = async () => {
  const { data } = await client.query<GetProductPageDataQuery>({
    query: GetProductPageDataDocument,
  })

  return data
}

export default function Page() {
  const data = useTypedLoaderData<GetProductPageDataQuery>()

  return (
    <div>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title'>計測対象一覧</h2>
            <div className='flex justify-end'>
              <a className='btn' href='/products'>
                計測対象を追加
              </a>
            </div>
            <ProductsTable products={data.products} />
          </div>
        </div>
      </div>
    </div>
  )
}
