import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import ProductsTable from '@/features/admin/products/components/ProductsTable'
import { useCreateProductModalQuery } from '@/features/admin/products/hooks/useCreateProductModalState'
import { getCategories, getProducts } from '@/server-actions/api'

const Page = async ({ searchParams }: { searchParams: { [key: string]: string | undefined } }) => {
  const productResponse = await getProducts()
  const categoryResponse = await getCategories({ rootOnly: true })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title'>計測対象一覧</h2>
            <div className='flex justify-end'>
              <Link
                className='btn'
                href={{
                  query: {
                    ...searchParams,
                    [useCreateProductModalQuery]: 'true',
                  },
                }}
              >
                計測対象を追加
              </Link>
            </div>
            <ProductsTable
              products={productResponse?.data?.products || []}
              categories={categoryResponse?.data?.categories || []}
            />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
