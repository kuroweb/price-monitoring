import type { GetCategoriesPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import CategoriesCard from '@/features/categories/components/CategoriesCard'
import CreateCategoryCard from '@/features/categories/components/CreateCategoryCard'
import { GetCategoriesPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async () => {
  const { data } = await getClient().query<GetCategoriesPageDataQuery>({
    query: GetCategoriesPageDataDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <CreateCategoryCard />
        <CategoriesCard categories={data.categories} />
      </div>
    </Layout>
  )
}

export default Page
