import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
import CategoriesList from '@/features/admin/categories/components/CategoriesList'
import { useCreateCategoryModalQuery } from '@/features/admin/categories/components/create-category-modal/hooks/useCreateCategoryModalState'
import { getCategories, getCategoriesStructured } from '@/lib/actions'

const Page = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>
}) => {
  const resolvedSearchParams = await searchParams
  const categoriesResponse = await getCategories()
  const categoriesStructuredResponse = await getCategoriesStructured({
    rootOnly: true,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-base-300'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>カテゴリ一覧</h2>
            <div className='flex justify-end pb-2'>
              <Link
                className='btn'
                href={{
                  query: {
                    ...resolvedSearchParams,
                    [useCreateCategoryModalQuery]: 'true',
                  },
                }}
              >
                カテゴリを追加
              </Link>
            </div>
            <CategoriesList
              structuredCategories={categoriesStructuredResponse.data?.categories || []}
              categories={categoriesResponse.data?.categories || []}
            />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
