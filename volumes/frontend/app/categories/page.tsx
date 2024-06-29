import type { GetCategoriesPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import CreateCategoryForm from '@/features/categories/components/CreateCategoryForm'
import { GetCategoriesPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async () => {
  const { data } = await getClient().query<GetCategoriesPageDataQuery>({
    query: GetCategoriesPageDataDocument,
  })

  type ChildCategory = {
    id: string
    name: string
    children: ChildCategory[]
  }

  const renderChildren = (children: ChildCategory[], depth: number = 1) => {
    return children.map((child): JSX.Element => {
      return (
        <>
          <li key={child.id}>
            {'__'.repeat(depth)}id: {child.id}, name: {child.name}
          </li>
          {renderChildren(child.children, depth + 1)}
        </>
      )
    })
  }

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>カテゴリ追加</h2>
            <CreateCategoryForm />
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>カテゴリ一覧</h2>
            <ul>
              {data.categories.map((category) => {
                return (
                  <>
                    <li key={category.id}>
                      id: {category.id}, name: {category.name}
                    </li>
                    {renderChildren(category.children as ChildCategory[])}
                  </>
                )
              })}
            </ul>
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
