import type { GetCategoryPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import CategoriesList from '@/features/admin/categories/components/CategoriesList'
import CreateCategoryForm from '@/features/admin/categories/components/CreateCategoryForm'
import { GetCategoryPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async () => {
  const { data } = await getClient().query<GetCategoryPageDataQuery>({
    query: GetCategoryPageDataDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>カテゴリ追加</h2>
            <CreateCategoryForm categories={data.categories} />
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>カテゴリ一覧</h2>
            <CategoriesList categoryTree={data.categoryTree} />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
