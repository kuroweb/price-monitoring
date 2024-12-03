import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
// import BulkEditExcludeKeywordModal from '@/features/admin/products/components/bulk-edit-exclude-keyword-modal/BulkEditExcludeKeywordModal'
// import BulkEditRequiredKeywordModal from '@/features/admin/products/components/bulk-edit-required-keyword-modal/BulkEditRequiredKeywordModal'
// import EditExcludeProductModal from '@/features/admin/products/components/edit-exclude-product-modal/EditExcludeProductModal'
import UpdateProductModal from '@/features/admin/products/components/update-product-modal'
import { useBulkEditExcludeKeywordModalQuery } from '@/features/admin/products/hooks/useBulkEditExcludeKeywordModalState'
import { useBulkEditRequiredKeywordModalQuery } from '@/features/admin/products/hooks/useBulkEditRequiredKeywordModalState'
import { useEditExcludeKeywordModalQuery } from '@/features/admin/products/hooks/useEditExcludeKeywordModalState'
import { useEditExcludeProductModalQuery } from '@/features/admin/products/hooks/useEditExcludeProductModalState'
import { useEditRequiredKeywordModalQuery } from '@/features/admin/products/hooks/useEditRequiredKeywordModalState'
import { useUpdateProductModalQuery } from '@/features/admin/products/hooks/useUpdateProductModalState'
import { getCategories, getProduct } from '@/server-actions/api'

const Page = async ({ params }: { params: { [key: string]: string | undefined } }) => {
  const productResponse = await getProduct(Number(params.id))
  const categoryResponse = await getCategories({ rootOnly: false })

  const currentPathname = `/admin/products/${params.id}`

  return (
    <>
      <Layout>
        <div className='grid grid-cols-1 gap-4'>
          <div className='card w-full bg-neutral'>
            <div className='card-body'>
              <h2 className='card-title pb-4'>設定</h2>
              <div className='grid grid-cols-2 gap-4 md:grid-cols-4'>
                <Link
                  className='btn'
                  href={{
                    pathname: currentPathname,
                    query: {
                      [useUpdateProductModalQuery]: 'true',
                    },
                  }}
                >
                  計測設定
                </Link>
                <Link
                  className='btn'
                  href={{
                    pathname: currentPathname,
                    query: {
                      [useEditRequiredKeywordModalQuery]: 'true',
                    },
                  }}
                >
                  必須キーワード
                </Link>
                <Link
                  className='btn'
                  href={{
                    pathname: currentPathname,
                    query: {
                      [useEditExcludeKeywordModalQuery]: 'true',
                    },
                  }}
                >
                  除外キーワード
                </Link>
                <Link
                  className='btn'
                  href={{
                    pathname: currentPathname,
                    query: {
                      [useEditExcludeProductModalQuery]: 'true',
                    },
                  }}
                >
                  除外商品ID
                </Link>
              </div>
            </div>
          </div>
          <div className='card w-full bg-neutral'>
            <div className='card-body'>
              <h2 className='card-title pb-4'>一括設定</h2>
              <div className='grid grid-cols-2 gap-4 md:grid-cols-4'>
                <Link
                  className='btn'
                  href={{
                    pathname: currentPathname,
                    query: {
                      [useBulkEditRequiredKeywordModalQuery]: 'true',
                    },
                  }}
                >
                  必須キーワード
                </Link>
                <Link
                  className='btn'
                  href={{
                    pathname: currentPathname,
                    query: {
                      [useBulkEditExcludeKeywordModalQuery]: 'true',
                    },
                  }}
                >
                  除外キーワード
                </Link>
              </div>
            </div>
          </div>
        </div>
        <UpdateProductModal
          productId={productResponse?.data?.id || 0}
          defaultValues={{
            name: productResponse?.data?.name || '',
            categoryId:
              productResponse?.data?.category?.id || categoryResponse?.data?.categories[0].id || 0,
            yahooAuctionCrawlSetting: {
              keyword: productResponse?.data?.yahooAuctionCrawlSetting?.keyword || '',
              categoryId: productResponse?.data?.yahooAuctionCrawlSetting?.categoryId || null,
              minPrice: productResponse?.data?.yahooAuctionCrawlSetting?.minPrice || 0,
              maxPrice: productResponse?.data?.yahooAuctionCrawlSetting?.maxPrice || 0,
              enabled: productResponse?.data?.yahooAuctionCrawlSetting?.enabled || true,
              yahooAuctionCrawlSettingExcludeKeywords:
                productResponse?.data?.yahooAuctionCrawlSetting
                  ?.yahooAuctionCrawlSettingExcludeKeywords || [],
              yahooAuctionCrawlSettingRequiredKeywords:
                productResponse?.data?.yahooAuctionCrawlSetting
                  ?.yahooAuctionCrawlSettingRequiredKeywords || [],
            },
            mercariCrawlSetting: {
              keyword: productResponse?.data?.mercariCrawlSetting?.keyword || '',
              categoryId: productResponse?.data?.mercariCrawlSetting?.categoryId || null,
              minPrice: productResponse?.data?.mercariCrawlSetting?.minPrice || 0,
              maxPrice: productResponse?.data?.mercariCrawlSetting?.maxPrice || 0,
              enabled: productResponse?.data?.mercariCrawlSetting?.enabled || true,
              mercariCrawlSettingExcludeKeywords:
                productResponse?.data?.mercariCrawlSetting?.mercariCrawlSettingExcludeKeywords ||
                [],
              mercariCrawlSettingRequiredKeywords:
                productResponse?.data?.mercariCrawlSetting?.mercariCrawlSettingRequiredKeywords ||
                [],
            },
            janparaCrawlSetting: {
              keyword: productResponse?.data?.janparaCrawlSetting?.keyword || '',
              minPrice: productResponse?.data?.janparaCrawlSetting?.minPrice || 0,
              maxPrice: productResponse?.data?.janparaCrawlSetting?.maxPrice || 0,
              enabled: productResponse?.data?.janparaCrawlSetting?.enabled || true,
              janparaCrawlSettingExcludeKeywords:
                productResponse?.data?.janparaCrawlSetting?.janparaCrawlSettingExcludeKeywords ||
                [],
              janparaCrawlSettingRequiredKeywords:
                productResponse?.data?.janparaCrawlSetting?.janparaCrawlSettingRequiredKeywords ||
                [],
            },
            iosysCrawlSetting: {
              keyword: productResponse?.data?.iosysCrawlSetting?.keyword || '',
              minPrice: productResponse?.data?.iosysCrawlSetting?.minPrice || 0,
              maxPrice: productResponse?.data?.iosysCrawlSetting?.maxPrice || 0,
              enabled: productResponse?.data?.iosysCrawlSetting?.enabled || true,
              iosysCrawlSettingExcludeKeywords:
                productResponse?.data?.iosysCrawlSetting?.iosysCrawlSettingExcludeKeywords || [],
              iosysCrawlSettingRequiredKeywords:
                productResponse?.data?.iosysCrawlSetting?.iosysCrawlSettingRequiredKeywords || [],
            },
            pcKoubouCrawlSetting: {
              keyword: productResponse?.data?.pcKoubouCrawlSetting?.keyword || '',
              minPrice: productResponse?.data?.pcKoubouCrawlSetting?.minPrice || 0,
              maxPrice: productResponse?.data?.pcKoubouCrawlSetting?.maxPrice || 0,
              enabled: productResponse?.data?.pcKoubouCrawlSetting?.enabled || true,
              pcKoubouCrawlSettingExcludeKeywords:
                productResponse?.data?.pcKoubouCrawlSetting?.pcKoubouCrawlSettingExcludeKeywords ||
                [],
              pcKoubouCrawlSettingRequiredKeywords:
                productResponse?.data?.pcKoubouCrawlSetting?.pcKoubouCrawlSettingRequiredKeywords ||
                [],
            },
            usedSofmapCrawlSetting: {
              keyword: productResponse?.data?.usedSofmapCrawlSetting?.keyword || '',
              minPrice: productResponse?.data?.usedSofmapCrawlSetting?.minPrice || 0,
              maxPrice: productResponse?.data?.usedSofmapCrawlSetting?.maxPrice || 0,
              enabled: productResponse?.data?.usedSofmapCrawlSetting?.enabled || true,
              usedSofmapCrawlSettingExcludeKeywords:
                productResponse?.data?.usedSofmapCrawlSetting
                  ?.usedSofmapCrawlSettingExcludeKeywords || [],
              usedSofmapCrawlSettingRequiredKeywords:
                productResponse?.data?.usedSofmapCrawlSetting
                  ?.usedSofmapCrawlSettingRequiredKeywords || [],
            },
          }}
          categories={categoryResponse?.data?.categories || []}
        />
        {/* <EditExcludeProductModal data={data} />
        <BulkEditExcludeKeywordModal
          yahooAuctionCrawlSettingExcludeKeywords={
            data.product.yahooAuctionCrawlSetting.yahooAuctionCrawlSettingExcludeKeywords
          }
          mercariCrawlSettingExcludeKeywords={
            data.product.mercariCrawlSetting.mercariCrawlSettingExcludeKeywords
          }
          janparaCrawlSettingExcludeKeywords={
            data.product.janparaCrawlSetting.janparaCrawlSettingExcludeKeywords
          }
          iosysCrawlSettingExcludeKeywords={
            data.product.iosysCrawlSetting.iosysCrawlSettingExcludeKeywords
          }
          pcKoubouCrawlSettingExcludeKeywords={
            data.product.pcKoubouCrawlSetting.pcKoubouCrawlSettingExcludeKeywords
          }
          usedSofmapCrawlSettingExcludeKeywords={
            data.product.usedSofmapCrawlSetting.usedSofmapCrawlSettingExcludeKeywords
          }
        />
        <BulkEditRequiredKeywordModal
          yahooAuctionCrawlSettingRequiredKeywords={
            data.product.yahooAuctionCrawlSetting.yahooAuctionCrawlSettingRequiredKeywords
          }
          mercariCrawlSettingRequiredKeywords={
            data.product.mercariCrawlSetting.mercariCrawlSettingRequiredKeywords
          }
          janparaCrawlSettingRequiredKeywords={
            data.product.janparaCrawlSetting.janparaCrawlSettingRequiredKeywords
          }
          iosysCrawlSettingRequiredKeywords={
            data.product.iosysCrawlSetting.iosysCrawlSettingRequiredKeywords
          }
          pcKoubouCrawlSettingRequiredKeywords={
            data.product.pcKoubouCrawlSetting.pcKoubouCrawlSettingRequiredKeywords
          }
          usedSofmapCrawlSettingRequiredKeywords={
            data.product.usedSofmapCrawlSetting.usedSofmapCrawlSettingRequiredKeywords
          }
        /> */}
      </Layout>
    </>
  )
}

export default Page
