'use client'

import { useCreateCrawlSettingModal } from '../hooks/useCreateCrawlSettingModal'

import ProductsTable from './ProductsTable'

import { GetProductPageDataQuery } from '@/graphql/dist/client'

const ProductsCard = ({ data }: { data: GetProductPageDataQuery }) => {
  const [_, setModal] = useCreateCrawlSettingModal()

  return (
    <>
      <div className='card w-full bg-neutral'>
        <div className='card-body'>
          <h2 className='card-title'>計測対象一覧</h2>
          <div className='flex justify-end'>
            <button onClick={() => setModal(true)} className='btn no-animation'>
              計測対象を追加
            </button>
          </div>
          <ProductsTable data={data} />
        </div>
      </div>
    </>
  )
}

export default ProductsCard
