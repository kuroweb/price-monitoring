import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import { getCategories } from '@/features/categories/api/actions'
import ProductsTable from '@/features/products/components/ProductsTable'
import { useCreateProductModalQuery } from '@/features/products/hooks/useCreateProductModalState'
import { getProducts } from '@/lib/actions'

const Page = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>
}) => {
  const resolvedSearchParams = await searchParams
  const productResponse = await getProducts()
  const categoryResponse = await getCategories({ rootOnly: false })

  if (
    productResponse.status !== 200 ||
    !productResponse.data ||
    categoryResponse.status !== 200 ||
    !categoryResponse.data
  ) {
    throw new Error('計測対象の取得に失敗しました')
  }

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-base-300'>
          <div className='card-body'>
            <h2 className='card-title'>計測対象の管理</h2>
            <div className='flex justify-end'>
              <Link
                className='btn'
                href={{
                  query: {
                    ...resolvedSearchParams,
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
