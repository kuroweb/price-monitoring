import Link from 'next/link'

import type { GetProductPageDataQuery } from '@/graphql/dist/client'

import Layout from '@/components/layouts/Layout'
import ProductsTable from '@/features/products/components/ProductsTable'
import CreateCrawlSettingModal from '@/features/products/components/create-crawl-setting-modal/CreateCrawlSettingModal'
import { useCreateCrawlSettingModalQuery } from '@/features/products/hooks/useCreateCrawlSettingModalState'
import { GetProductPageDataDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

const Page = async ({ searchParams }: { searchParams: { [key: string]: string | undefined } }) => {
  const { data } = await getClient().query<GetProductPageDataQuery>({
    query: GetProductPageDataDocument,
  })

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title'>計測対象一覧</h2>
            <div className='flex justify-end'>
              <Link
                className='btn'
                href={{
                  pathname: '/',
                  query: {
                    ...searchParams,
                    [useCreateCrawlSettingModalQuery]: 'true',
                  },
                }}
              >
                計測対象を追加
              </Link>
            </div>
            <ProductsTable data={data} />
          </div>
        </div>
      </div>
      <CreateCrawlSettingModal />
    </Layout>
  )
}

export default Page
