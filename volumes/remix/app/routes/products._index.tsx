import { useTypedLoaderData } from 'remix-typedjson'

import ProductsTable from '../../features/products/components/ProductsTable'

import type { LoaderFunction } from '@remix-run/node'

import CreateProductModal from '@/features/products/components/create-product-modal/CreateProductModal'
import { useCreateProductModalStore } from '@/features/products/stores/create-product-modal-store'
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
  const { open } = useCreateProductModalStore()

  return (
    <>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title'>計測対象一覧</h2>
            <div className='flex justify-end'>
              <button className='btn' onClick={() => open()}>
                計測対象を追加
              </button>
            </div>
            <ProductsTable products={data.products} />
          </div>
        </div>
      </div>
      <CreateProductModal />
    </>
  )
}
