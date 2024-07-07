import type { GetCategoryPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import CategoriesCard from '@/features/categories/components/CategoriesCard'
import CreateCategoryCard from '@/features/categories/components/CreateCategoryCard'
import { GetCategoryPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async () => {
  const { data } = await getClient().query<GetCategoryPageDataQuery>({
    query: GetCategoryPageDataDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <CreateCategoryCard categories={data.categories} />
        <CategoriesCard categoryTree={data.categoryTree} />
      </div>
    </Layout>
  )
}

export default Page
