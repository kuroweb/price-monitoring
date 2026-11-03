import Layout from '@/components/layouts/Layout'
import CategoryNavigation from '@/features/products/components/CategoryNavigation'
import ProductPriceList from '@/features/products/components/ProductPriceList'
import {
  categoryIdStateCache,
  useCategoryIdStateQuery,
} from '@/features/products/hooks/useCategoryIdState'
import {
  getCategories,
  getCategoriesStructured,
  getCategoryStructuredSubtree,
  getProductPrices,
  getProducts,
} from '@/lib/actions'

const Page = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>
}) => {
  const resolvedSearchParams = await searchParams
  const { [useCategoryIdStateQuery]: categoryId } = categoryIdStateCache.parse(resolvedSearchParams)

  let currentCategory, parentCategory, childCategories
  if (categoryId === -1) {
    const response = await getCategoriesStructured({ rootOnly: true })
    if (response.status < 200 || response.status >= 300 || !response.data)
      throw new Error('カテゴリを取得できませんでした')
    currentCategory = undefined
    parentCategory = undefined
    childCategories = response.data?.categories || []
  } else {
    const response = await getCategoryStructuredSubtree(categoryId)
    if (response.status < 200 || response.status >= 300 || !response.data)
      throw new Error('カテゴリを取得できませんでした')
    currentCategory = response.data || undefined
    parentCategory = response.data?.parent || undefined
    childCategories = response.data?.children || []
  }

  const [productPricesResponse, productResponse, categoryResponse] = await Promise.all([
    getProductPrices({
      categoryId: categoryId === -1 ? null : categoryId,
      platformMask:
        'yahoo_auction.buyable,yahoo_fleamarket.published,mercari.published,janpara.all,iosys.all,pc_koubou.all',
      sort: 'price',
      order: 'asc',
      priceDisplayLimit: 20,
    }),
    getProducts(),
    getCategories({ rootOnly: false }),
  ])
  if (
    [productPricesResponse, productResponse, categoryResponse].some(
      (response) => response.status < 200 || response.status >= 300 || !response.data,
    )
  )
    throw new Error('商品情報を取得できませんでした')
  const productPrices = productPricesResponse.data ?? []

  return (
    <Layout>
      <div className='grid grid-cols-1 space-y-4'>
        <div className='card bg-base-300'>
          <div className='card-body'>
            <CategoryNavigation
              currentCategory={currentCategory}
              parentCategory={parentCategory}
              childCategories={childCategories}
            />
          </div>
        </div>
        <div className='card bg-base-300'>
          <div className='card-body'>
            <ProductPriceList
              productPrices={productPrices}
              products={productResponse.data?.products ?? []}
              categories={categoryResponse.data?.categories ?? []}
            />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
