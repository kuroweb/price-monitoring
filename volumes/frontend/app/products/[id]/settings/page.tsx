import Link from 'next/link'

import type { GetProductSettingPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import Menu from '@/features/products/components/Menu'
import BulkEditExcludeKeywordModal from '@/features/products/components/bulk-edit-exclude-keyword-modal/BulkEditExcludeKeywordModal'
import BulkEditRequiredKeywordModal from '@/features/products/components/bulk-edit-required-keyword-modal/BulkEditRequiredKeywordModal'
import EditExcludeKeywordModal from '@/features/products/components/edit-exclude-keyword-modal/EditExcludeKeywordModal'
import EditExcludeProductModal from '@/features/products/components/edit-exclude-product-modal/EditExcludeProductModal'
import EditRequiredKeywordModal from '@/features/products/components/edit-required-keyword-modal/EditRequiredKeywordModal'
import UpdateProductModal from '@/features/products/components/update-product-modal/UpdateProductModal'
import { useBulkEditExcludeKeywordModalQuery } from '@/features/products/hooks/useBulkEditExcludeKeywordModalState'
import { useBulkEditRequiredKeywordModalQuery } from '@/features/products/hooks/useBulkEditRequiredKeywordModalState'
import { useEditExcludeKeywordModalQuery } from '@/features/products/hooks/useEditExcludeKeywordModalState'
import { useEditExcludeProductModalQuery } from '@/features/products/hooks/useEditExcludeProductModalState'
import { useEditRequiredKeywordModalQuery } from '@/features/products/hooks/useEditRequiredKeywordModalState'
import { useUpdateProductModalQuery } from '@/features/products/hooks/useUpdateProductModalState'
import { GetProductSettingPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

const Page = async ({ params }: { params: { [key: string]: string | undefined } }) => {
  const { data } = await getClient().query<GetProductSettingPageDataQuery>({
    query: GetProductSettingPageDataDocument,
    variables: {
      id: params.id,
    },
  })

  const currentPathname = `/products/${params.id}/settings`

  return (
    <>
      <Layout>
        <div className='grid grid-cols-1 gap-4'>
          <Menu />
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
          defaultValues={{
            id: String(params.id),
            name: data.product.name,
            yahooAuctionCrawlSetting: {
              keyword: data.product.yahooAuctionCrawlSetting?.keyword,
              categoryId: data.product.yahooAuctionCrawlSetting?.categoryId,
              minPrice: data.product.yahooAuctionCrawlSetting?.minPrice,
              maxPrice: data.product.yahooAuctionCrawlSetting?.maxPrice,
              enabled: data.product.yahooAuctionCrawlSetting?.enabled,
            },
            mercariCrawlSetting: {
              keyword: data.product.mercariCrawlSetting?.keyword,
              categoryId: data.product.mercariCrawlSetting?.categoryId,
              minPrice: data.product.mercariCrawlSetting?.minPrice,
              maxPrice: data.product.mercariCrawlSetting?.maxPrice,
              enabled: data.product.mercariCrawlSetting?.enabled,
            },
            janparaCrawlSetting: {
              keyword: data.product.janparaCrawlSetting?.keyword,
              minPrice: data.product.janparaCrawlSetting?.minPrice,
              maxPrice: data.product.janparaCrawlSetting?.maxPrice,
              enabled: data.product.janparaCrawlSetting?.enabled,
            },
            iosysCrawlSetting: {
              keyword: data.product.iosysCrawlSetting?.keyword,
              minPrice: data.product.iosysCrawlSetting?.minPrice,
              maxPrice: data.product.iosysCrawlSetting?.maxPrice,
              enabled: data.product.iosysCrawlSetting?.enabled,
            },
            pcKoubouCrawlSetting: {
              keyword: data.product.pcKoubouCrawlSetting?.keyword,
              minPrice: data.product.pcKoubouCrawlSetting?.minPrice,
              maxPrice: data.product.pcKoubouCrawlSetting?.maxPrice,
              enabled: data.product.pcKoubouCrawlSetting?.enabled,
            },
            usedSofmapCrawlSetting: {
              keyword: data.product.usedSofmapCrawlSetting?.keyword,
              minPrice: data.product.usedSofmapCrawlSetting?.minPrice,
              maxPrice: data.product.usedSofmapCrawlSetting?.maxPrice,
              enabled: data.product.usedSofmapCrawlSetting?.enabled,
            },
          }}
        />
        <EditExcludeKeywordModal data={data} />
        <EditExcludeProductModal data={data} />
        <EditRequiredKeywordModal data={data} />
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
        />
      </Layout>
    </>
  )
}

export default Page
