import Link from 'next/link'

import Layout from '@/components/layouts/Layout'
// import BulkEditExcludeKeywordModal from '@/features/admin/products/components/bulk-edit-exclude-keyword-modal/BulkEditExcludeKeywordModal'
// import BulkEditRequiredKeywordModal from '@/features/admin/products/components/bulk-edit-required-keyword-modal/BulkEditRequiredKeywordModal'
// import EditExcludeProductModal from '@/features/admin/products/components/edit-exclude-product-modal/EditExcludeProductModal'
import UpdateProductModal from '@/features/admin/products/common/components/update-product-modal/UpdateProductModal'
import { useUpdateProductModalQuery } from '@/features/admin/products/common/components/update-product-modal/hooks/useUpdateProductModalState'
import { useBulkEditExcludeKeywordModalQuery } from '@/features/admin/products/components/bulk-edit-exclude-keyword-modal/hooks/useBulkEditExcludeKeywordModalState'
import { useBulkEditRequiredKeywordModalQuery } from '@/features/admin/products/components/bulk-edit-required-keyword-modal/hooks/useBulkEditRequiredKeywordModalState'
import { useEditExcludeProductModalQuery } from '@/features/admin/products/components/edit-exclude-product-modal/hooks/useEditExcludeProductModalState'
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
          product={productResponse?.data || undefined}
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
