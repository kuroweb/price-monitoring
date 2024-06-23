import type { GetCategoriesPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import { GetCategoriesPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async () => {
  const { data } = await getClient().query<GetCategoriesPageDataQuery>({
    query: GetCategoriesPageDataDocument,
  })

  const renderCategories = (
    categories: GetCategoriesPageDataQuery['categories'],
    depth: number = 0,
  ) => {
    if (!categories || categories.length === 0) return <></>

    return (
      <ul>
        {categories.map((category) => (
          <li key={category.id}>
            <span>
              {'__'.repeat(depth)}
              {category.name}
            </span>
            {renderCategories(category.children, depth + 1)}
          </li>
        ))}
      </ul>
    )
  }

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>カテゴリ</h2>
            {renderCategories(data.categories)}
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
