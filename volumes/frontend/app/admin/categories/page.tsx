import Layout from '@/components/layouts/Layout'
import CategoriesList from '@/features/admin/categories/components/CategoriesList'
import CreateCategoryForm from '@/features/admin/categories/components/CreateCategoryForm'
import { getCategories, getCategoriesStructured } from '@/server-actions/api'

const Page = async () => {
  const categoriesResponse = await getCategories()
  const categoriesStructuredResponse = await getCategoriesStructured({
    rootOnly: true,
    displayDepthLimit: 2,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>カテゴリ追加</h2>
            <CreateCategoryForm categories={categoriesResponse.data?.categories || []} />
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>カテゴリ一覧</h2>
            <CategoriesList
              structuredCategories={categoriesStructuredResponse.data?.categories || []}
            />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
